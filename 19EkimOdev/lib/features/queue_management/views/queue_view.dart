import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../core/widgets/status_filter_bar.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../controllers/queue_controller.dart';
import '../controllers/visit_actions.dart';
import '../widgets/visit_card.dart';
import 'visit_detail_view.dart';

/// Günlük kan alma sırası: arama, filtre ve satır aksiyonları.
class QueueView extends StatefulWidget {
  const QueueView({
    super.key,
    required this.store,
    required this.controller,
    required this.actions,
  });

  final DemoClinicStore store;
  final QueueController controller;
  final VisitActions actions;

  @override
  State<QueueView> createState() => _QueueViewState();
}

class _QueueViewState extends State<QueueView> {
  // Controller build içinde değil, initState'te oluşturulur.
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.controller.query.value);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchCtrl.clear();
    widget.controller.search('');
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: ValueListenableBuilder<ClinicState>(
        valueListenable: widget.store.state,
        builder: (BuildContext context, ClinicState state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PageHeader(
                title: 'Kan Alma Sırası',
                subtitle: 'Bugün ${state.visits.length} kayıt · '
                    '${state.countByStatus(CollectionStatus.waiting)} bekliyor',
                trailing: FilledButton.tonalIcon(
                  key: const Key('queue_call_next'),
                  onPressed: state.nextWaiting == null
                      ? null
                      : () => widget.actions.callNext(context),
                  icon: const Icon(Icons.campaign_outlined),
                  label: const Text('Çağır'),
                ),
              ),
              _SearchField(
                controller: _searchCtrl,
                onChanged: widget.controller.search,
                onClear: _clearSearch,
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<CollectionStatus?>(
                valueListenable: widget.controller.filter,
                builder: (BuildContext context, CollectionStatus? filter, _) {
                  return StatusFilterBar<CollectionStatus>(
                    options: _filterOptions(state),
                    selected: filter,
                    onSelected: widget.controller.setFilter,
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

  List<FilterOption<CollectionStatus>> _filterOptions(ClinicState state) {
    return <FilterOption<CollectionStatus>>[
      FilterOption<CollectionStatus>(
        value: null,
        label: 'Tümü',
        count: state.visits.length,
      ),
      for (final CollectionStatus s in CollectionStatus.values)
        FilterOption<CollectionStatus>(
          value: s,
          label: s.label,
          count: state.countByStatus(s),
          icon: s.icon,
        ),
    ];
  }

  Widget _buildList(ClinicState state) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.controller.query,
      builder: (BuildContext context, String query, _) {
        return ValueListenableBuilder<CollectionStatus?>(
          valueListenable: widget.controller.filter,
          builder: (BuildContext context, CollectionStatus? filter, _) {
            final List<CollectionVisit> visits =
                QueueController.apply(state, query: query, filter: filter);

            if (visits.isEmpty) {
              return SingleChildScrollView(
                child: EmptyState(
                  icon: Icons.manage_search_rounded,
                  title: 'Kayıt bulunamadı',
                  message: query.trim().isNotEmpty || filter != null
                      ? 'Arama veya filtre ile eşleşen bir kayıt yok.'
                      : 'Bugün için henüz kayıt yok. Yeni hasta ekleyin.',
                  action: query.trim().isNotEmpty || filter != null
                      ? OutlinedButton.icon(
                          onPressed: () {
                            _clearSearch();
                            widget.controller.setFilter(null);
                          },
                          icon: const Icon(Icons.filter_alt_off_outlined),
                          label: const Text('Filtreleri Temizle'),
                        )
                      : null,
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
              itemCount: visits.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final CollectionVisit visit = visits[index];
                return VisitCard(
                  key: ValueKey<String>(visit.id),
                  visit: visit,
                  patient: state.patientOf(visit),
                  onOpen: () => VisitDetailView.open(
                      context, widget.store, widget.actions, visit.id),
                  onAdvance: () => widget.actions.advance(context, visit),
                  onCancel: () => widget.actions.cancel(context, visit),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (BuildContext context, TextEditingValue value, _) {
          return TextField(
            key: const Key('queue_search'),
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Ad, demo kod, sıra no (${Formatters.queueNumber(7)}) '
                  'veya birim ara',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Aramayı temizle',
                      onPressed: onClear,
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          );
        },
      ),
    );
  }
}
