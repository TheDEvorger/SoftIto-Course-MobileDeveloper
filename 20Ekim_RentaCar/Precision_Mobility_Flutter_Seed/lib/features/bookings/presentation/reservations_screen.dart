import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/design/action_state.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/domain/vehicle.dart';
import '../application/reservation_controller.dart';
import '../domain/reservation.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen(
      {super.key,
      required this.controller,
      required this.connected,
      required this.onConnect,
      required this.onDiscover,
      required this.onChanged});
  final ReservationController controller;
  final bool connected;
  final VoidCallback onConnect, onDiscover, onChanged;
  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  String _filter = 'all';
  final Set<String> _pending = {};
  Future<void> _cancel(String id) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Planınızı iptal edelim mi?'),
                content: const Text(
                    'Rezervasyon iptal edildi olarak saklanır ve araç bu tarihlerde yeniden müsait olur. Ödeme veya iade işlemi yapılmaz.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Vazgeç')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('İptal et'))
                ]));
    if (confirm != true || !mounted) return;
    setState(() => _pending.add(id));
    try {
      await widget.controller.cancel(id);
      if (mounted) widget.onChanged();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error is ApiException
                ? error.message
                : 'İptal işlemi tamamlanamadı.')));
      }
    } finally {
      if (mounted) setState(() => _pending.remove(id));
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller;
        final records = state.records
            .where((r) =>
                _filter == 'all' ||
                (_filter == 'active' ? !r.cancelled : r.cancelled))
            .toList();
        return StudioPage(children: [
          PageHeading(
              eyebrow: 'Yolculuklar / Rezervasyonlar',
              title: 'Sıradaki güzel planınız.',
              description:
                  'Yolculuk takviminiz, rezervasyonlarınız ve geçmiş kayıtlarınız.',
              action: OutlinedButton.icon(
                  onPressed: widget.onDiscover,
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text('Yeni yolculuk planla'))),
          const SizedBox(height: 32),
          if (!widget.connected)
            ActionState(
                title: 'Planlarınızı bir araya getirin.',
                message:
                    'Kayıtlı rezervasyonları görmek için çalışma alanınıza bağlanın.',
                icon: Icons.event_note_outlined,
                action: widget.onConnect,
                label: 'Çalışma alanına bağlan')
          else ...[
            Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 20,
                runSpacing: 12,
                children: [
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    for (final f in const [
                      ('all', 'Tümü'),
                      ('active', 'Aktif planlar'),
                      ('cancelled', 'İptal edilen')
                    ])
                      ChoiceChip(
                          label: Text(f.$2),
                          selected: _filter == f.$1,
                          onSelected: (_) => setState(() => _filter = f.$1)),
                  ]),
                  IconButton(
                      onPressed: state.loading ? null : state.load,
                      tooltip: 'Rezervasyonları yenile',
                      icon: const Icon(Icons.refresh)),
                ]),
            const SizedBox(height: 24),
            if (state.loading)
              const LinearProgressIndicator()
            else if (state.error != null)
              ActionState(
                  title: 'Planlar yüklenemedi.',
                  message: state.error!,
                  icon: Icons.wifi_off_outlined,
                  action: state.load,
                  label: 'Yeniden dene')
            else if (records.isEmpty)
              ActionState(
                  title: 'Takviminizde yeni bir sayfa.',
                  message:
                      'Aracınızı ve tarihlerinizi seçin. Kaydettiğiniz rezervasyonlar burada görünsün.',
                  icon: Icons.route_outlined,
                  action: widget.onDiscover,
                  label: 'Araçları keşfet')
            else
              for (final record in records)
                Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: _card(context, record)),
          ],
        ]);
      });

  Widget _card(BuildContext context, Reservation record) =>
      StudioPanel(child: LayoutBuilder(builder: (context, constraints) {
        final dates = MaterialLocalizations.of(context);
        final content =
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
                record.cancelled
                    ? Icons.cancel_outlined
                    : Icons.event_available_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 7),
            Expanded(
                child: Text(
                    record.cancelled ? 'İptal edildi' : 'Rezerve edildi',
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary)))
          ]),
          const SizedBox(height: 12),
          Text(record.vehicleName,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
              '${dates.formatShortDate(record.start)} — ${dates.formatShortDate(record.end)}'),
          const SizedBox(height: 8),
          Text(
              '${rentalDays(record.start, record.end)} gün · ${record.totalLabel}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Kayıt: ${record.id}',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]);
        final action = OutlinedButton(
            onPressed:
                _pending.contains(record.id) ? null : () => _cancel(record.id),
            child: Text(_pending.contains(record.id)
                ? 'İşleniyor…'
                : 'Rezervasyonu iptal et'));
        if (constraints.maxWidth < 700) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                if (!record.cancelled) ...[const SizedBox(height: 22), action]
              ]);
        }
        return Row(children: [
          Container(
              width: 70,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18)),
              child: Text(
                  '${record.start.day.toString().padLeft(2, '0')}\n${record.start.month.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(width: 24),
          Expanded(child: content),
          const SizedBox(width: 20),
          if (!record.cancelled) action
        ]);
      }));
}
