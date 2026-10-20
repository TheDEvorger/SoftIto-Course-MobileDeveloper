import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/page_parts.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/demo/clinic_state.dart';
import '../../../data/demo/demo_clinic_store.dart';
import '../../../data/models/collection_status.dart';
import '../../../data/models/collection_visit.dart';
import '../../../data/models/demo_patient.dart';
import '../../../data/models/demo_specimen.dart';
import '../controllers/visit_actions.dart';
import '../widgets/status_timeline.dart';

/// Tek bir işlemin detayı ve durum akışı.
///
/// Store'u dinlediği için başka bir ekranda yapılan değişiklik burada da
/// anında görünür.
class VisitDetailView extends StatelessWidget {
  const VisitDetailView({
    super.key,
    required this.store,
    required this.actions,
    required this.visitId,
  });

  final DemoClinicStore store;
  final VisitActions actions;
  final String visitId;

  /// Navigator + MaterialPageRoute ile detay sayfasını açar.
  static Future<void> open(
    BuildContext context,
    DemoClinicStore store,
    VisitActions actions,
    String visitId,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            VisitDetailView(store: store, actions: actions, visitId: visitId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ClinicState>(
      valueListenable: store.state,
      builder: (BuildContext context, ClinicState state, _) {
        final CollectionVisit? visit = state.visitById(visitId);
        if (visit == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('İşlem Detayı')),
            body: const EmptyState(
              icon: Icons.search_off_rounded,
              title: 'Kayıt bulunamadı',
              message: 'Bu kayıt demo sıfırlandığı için kaldırılmış olabilir.',
            ),
          );
        }
        final DemoPatient? patient = state.patientOf(visit);
        final DemoSpecimen? specimen = state.specimenForVisit(visit.id);

        return Scaffold(
          appBar: AppBar(
            title: Text('İşlem ${Formatters.queueNumber(visit.queueNumber)}'),
          ),
          bottomNavigationBar: visit.status.isTerminal
              ? null
              : _ActionBar(visit: visit, actions: actions),
          body: PageFrame(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: <Widget>[
                _HeaderCard(visit: visit, patient: patient),
                const SizedBox(height: 16),
                SectionCard(
                  title: 'İşlem Akışı',
                  icon: Icons.timeline_rounded,
                  child: StatusTimeline(visit: visit),
                ),
                const SizedBox(height: 16),
                _InfoCard(visit: visit),
                if (specimen != null) ...<Widget>[
                  const SizedBox(height: 16),
                  _SpecimenCard(specimen: specimen),
                ],
                const SizedBox(height: 16),
                const InfoBanner(
                  warning: true,
                  icon: Icons.verified_user_outlined,
                  title: 'Klinik prosedür uygulama dışındadır',
                  message: 'Hasta kimlik doğrulaması ve klinik kontroller, '
                      'kurumun gerçek prosedürüne göre yapılmalıdır. Bu eğitim '
                      'demosu bu adımları yapılmış saymaz.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.visit, required this.patient});

  final CollectionVisit visit;
  final DemoPatient? patient;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            QueueBadge(
              label: Formatters.queueNumber(visit.queueNumber),
              large: true,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(patient?.displayName ?? 'Bilinmeyen kayıt',
                      style: theme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    '${patient?.code ?? '-'} · ${patient?.department ?? '-'}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  StatusChip.visit(visit.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.visit});

  final CollectionVisit visit;

  @override
  Widget build(BuildContext context) {
    final DateTime? calledAt = visit.statusHistory[CollectionStatus.called];
    return SectionCard(
      title: 'Kayıt Bilgileri',
      icon: Icons.assignment_outlined,
      child: Column(
        children: <Widget>[
          _InfoRow(
            icon: Icons.login_rounded,
            label: 'Kabul saati',
            value: Formatters.shortDateTime(visit.createdAt),
          ),
          _InfoRow(
            icon: Icons.event_outlined,
            label: 'Randevu',
            value: visit.appointmentAt == null
                ? 'Randevusuz'
                : Formatters.time(visit.appointmentAt!),
          ),
          _InfoRow(
            icon: Icons.timer_outlined,
            label: 'Çağrılana kadar bekleme',
            value: calledAt == null
                ? 'Henüz çağrılmadı'
                : Formatters.duration(visit.createdAt, calledAt),
          ),
          _InfoRow(
            icon: Icons.sticky_note_2_outlined,
            label: 'Not',
            value: visit.note ?? '—',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value,
                textAlign: TextAlign.end, style: theme.textTheme.titleSmall),
          ),
        ],
      ),
    );
  }
}

class _SpecimenCard extends StatelessWidget {
  const _SpecimenCard({required this.specimen});

  final DemoSpecimen specimen;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SectionCard(
      title: 'Kurgusal Numune',
      icon: Icons.science_outlined,
      trailing: StatusChip.specimen(specimen.status),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SelectableText(
                  specimen.code,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Oluşturulma: ${Formatters.shortDateTime(specimen.createdAt)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton.outlined(
            tooltip: 'Numune kodunu kopyala',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: specimen.code));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text('${specimen.code} panoya kopyalandı.')));
            },
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.visit, required this.actions});

  final CollectionVisit visit;
  final VisitActions actions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color coral = context.palette.coral;
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: theme.colorScheme.outline)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Row(
                children: <Widget>[
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: coral,
                      side: BorderSide(color: coral.withValues(alpha: 0.5)),
                    ),
                    onPressed: () => actions.cancel(context, visit),
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('İptal'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      key: const Key('detail_advance'),
                      onPressed: () => actions.advance(context, visit),
                      icon: Icon(visit.status.nextActionIcon),
                      label: Text(visit.status.nextActionLabel ?? ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
