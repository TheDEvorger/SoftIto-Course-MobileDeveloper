import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../../queue_management/controllers/visit_actions.dart';
import '../../queue_management/views/visit_detail_view.dart';
import '../models/dashboard_summary.dart';
import '../widgets/activity_cards.dart';
import '../widgets/hero_panel.dart';
import '../widgets/stat_card.dart';
import '../widgets/workflow_card.dart';

/// Gösterge paneli: günlük özet, hızlı aksiyonlar ve son hareketler.
class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.store,
    required this.actions,
    required this.onNewPatient,
    required this.onOpenQueue,
  });

  final DemoClinicStore store;
  final VisitActions actions;
  final VoidCallback onNewPatient;

  /// Sıra sekmesini verilen filtreyle açar.
  final ValueChanged<CollectionStatus?> onOpenQueue;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: ValueListenableBuilder<ClinicState>(
        valueListenable: store.state,
        builder: (BuildContext context, ClinicState state, _) {
          final DashboardSummary summary = DashboardSummary.fromState(state);
          final CollectionVisit? next = state.nextWaiting;

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool wide = constraints.maxWidth >= 900;
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
                children: <Widget>[
                  HeroPanel(
                    today: DateTime.now(),
                    nextVisit: next,
                    nextPatient: next == null ? null : state.patientOf(next),
                    waitingCount: summary.waiting,
                    onCallNext: () => actions.callNext(context),
                    onNewPatient: onNewPatient,
                  ),
                  const SizedBox(height: 20),
                  _StatGrid(summary: summary, onOpenQueue: onOpenQueue),
                  const SizedBox(height: 20),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: _MainColumn(
                              state: state,
                              summary: summary,
                              store: store,
                              actions: actions),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: _recentActivity(context, state),
                        ),
                      ],
                    )
                  else ...<Widget>[
                    _MainColumn(
                        state: state,
                        summary: summary,
                        store: store,
                        actions: actions),
                    const SizedBox(height: 16),
                    _recentActivity(context, state),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _recentActivity(BuildContext context, ClinicState state) {
    return RecentActivityCard(
      activities: state.activities,
      onOpenVisit: (String id) =>
          VisitDetailView.open(context, store, actions, id),
    );
  }
}

class _MainColumn extends StatelessWidget {
  const _MainColumn({
    required this.state,
    required this.summary,
    required this.store,
    required this.actions,
  });

  final ClinicState state;
  final DashboardSummary summary;
  final DemoClinicStore store;
  final VisitActions actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ActiveCallsCard(
          state: state,
          visits: summary.activeVisits,
          onAdvance: (CollectionVisit v) => actions.advance(context, v),
          onOpen: (CollectionVisit v) =>
              VisitDetailView.open(context, store, actions, v.id),
        ),
        const SizedBox(height: 16),
        WorkflowCard(summary: summary),
      ],
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.summary, required this.onOpenQueue});

  final DashboardSummary summary;
  final ValueChanged<CollectionStatus?> onOpenQueue;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final VenaPalette palette = context.palette;
    final int percent = (summary.completionRate * 100).round();

    final List<Widget> cards = <Widget>[
      StatCard(
        key: const Key('stat_waiting'),
        label: 'Sırada Bekleyen',
        value: summary.waiting,
        caption: 'Çağrılmayı bekliyor',
        icon: Icons.hourglass_top_rounded,
        color: palette.amber,
        onTap: () => onOpenQueue(CollectionStatus.waiting),
      ),
      StatCard(
        key: const Key('stat_active'),
        label: 'İşlemde',
        value: summary.active,
        caption: '${summary.called} çağrıldı · ${summary.inProgress} işlemde',
        icon: Icons.vaccines_rounded,
        color: scheme.primary,
        onTap: () => onOpenQueue(CollectionStatus.inProgress),
      ),
      StatCard(
        key: const Key('stat_collected'),
        label: 'Numunesi Alınan',
        value: summary.sampleCollected,
        caption: 'Teslim bekliyor',
        icon: Icons.science_rounded,
        color: palette.primaryDark,
        onTap: () => onOpenQueue(CollectionStatus.sampleCollected),
      ),
      StatCard(
        key: const Key('stat_delivered'),
        label: 'Teslim Edilen',
        value: summary.delivered,
        caption: '%$percent tamamlandı · ${summary.cancelled} iptal',
        icon: Icons.task_alt_rounded,
        color: palette.success,
        onTap: () => onOpenQueue(CollectionStatus.delivered),
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double gap = 12;
        final int columns = constraints.maxWidth >= 720 ? 4 : 2;
        final double width =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final Widget card in cards)
              SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}
