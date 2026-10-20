import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../core/widgets/status_filter_bar.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/demo_specimen.dart';
import '../../queue_management/controllers/visit_actions.dart';
import '../../queue_management/views/visit_detail_view.dart';
import '../controllers/sample_tracking_controller.dart';
import '../models/specimen_row.dart';
import '../widgets/specimen_card.dart';

/// Kurgusal numunelerin listesi, araması ve filtresi.
class SampleTrackingView extends StatefulWidget {
  const SampleTrackingView({
    super.key,
    required this.store,
    required this.actions,
  });

  final DemoClinicStore store;
  final VisitActions actions;

  @override
  State<SampleTrackingView> createState() => _SampleTrackingViewState();
}

class _SampleTrackingViewState extends State<SampleTrackingView> {
  late final SampleTrackingController _controller;
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _controller = SampleTrackingController();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$code panoya kopyalandı.')));
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: ValueListenableBuilder<ClinicState>(
        valueListenable: widget.store.state,
        builder: (BuildContext context, ClinicState state, _) {
          final int awaiting = SampleTrackingController.countByStatus(
              state, SpecimenStatus.awaitingDelivery);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PageHeader(
                title: 'Numune Takibi',
                subtitle: '${state.specimens.length} kurgusal numune · '
                    '$awaiting teslim bekliyor',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  key: const Key('specimen_search'),
                  controller: _searchCtrl,
                  onChanged: _controller.search,
                  decoration: const InputDecoration(
                    hintText: 'Numune kodu, sıra no veya hasta ara',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<SpecimenStatus?>(
                valueListenable: _controller.filter,
                builder: (BuildContext context, SpecimenStatus? filter, _) {
                  return StatusFilterBar<SpecimenStatus>(
                    options: _filterOptions(state),
                    selected: filter,
                    onSelected: _controller.setFilter,
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildList(state)),
            ],
          );
        },
      ),
    );
  }

  List<FilterOption<SpecimenStatus>> _filterOptions(ClinicState state) {
    return <FilterOption<SpecimenStatus>>[
      FilterOption<SpecimenStatus>(
        value: null,
        label: 'Tümü',
        count: state.specimens.length,
      ),
      for (final SpecimenStatus s in SpecimenStatus.values)
        FilterOption<SpecimenStatus>(
          value: s,
          label: s.label,
          count: SampleTrackingController.countByStatus(state, s),
          icon: s.icon,
        ),
    ];
  }

  Widget _buildList(ClinicState state) {
    return ValueListenableBuilder<String>(
      valueListenable: _controller.query,
      builder: (BuildContext context, String query, _) {
        return ValueListenableBuilder<SpecimenStatus?>(
          valueListenable: _controller.filter,
          builder: (BuildContext context, SpecimenStatus? filter, _) {
            final List<SpecimenRow> rows = SampleTrackingController.apply(
                state, query: query, filter: filter);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: <Widget>[
                const InfoBanner(
                  icon: Icons.qr_code_scanner_rounded,
                  title: 'Bu sürümde barkod / LIS bağlantısı yok',
                  message: 'Numune kodları kurgusaldır. Gerçek barkod/QR '
                      'tarama, etiket basımı ve laboratuvar sistemi '
                      'entegrasyonu ileriki sürümler için planlanmıştır.',
                ),
                const SizedBox(height: 12),
                if (rows.isEmpty)
                  EmptyState(
                    icon: Icons.science_outlined,
                    title: 'Numune bulunamadı',
                    message: state.specimens.isEmpty
                        ? 'Kan alma işlemi tamamlanınca numuneler burada görünür.'
                        : 'Arama veya filtre ile eşleşen numune yok.',
                  )
                else
                  for (final SpecimenRow row in rows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SpecimenCard(
                        key: ValueKey<String>(row.specimen.id),
                        row: row,
                        onCopy: () => _copy(row.specimen.code),
                        onOpenDetail: row.visit == null
                            ? null
                            : () => VisitDetailView.open(context, widget.store,
                                widget.actions, row.visit!.id),
                        onDeliver: () {
                          if (row.visit != null) {
                            widget.actions.advance(context, row.visit!);
                          }
                        },
                      ),
                    ),
              ],
            );
          },
        );
      },
    );
  }
}
