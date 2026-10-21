import 'package:flutter/material.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../application/rental_controller.dart';
import '../domain/local_reservation.dart';
import '../domain/rental_vehicle.dart';
import 'rental_actions.dart';
import 'rental_car_card.dart';
import 'rental_plan_card.dart';

class RentalPlansScreen extends StatefulWidget {
  const RentalPlansScreen(
      {super.key,
      required this.controller,
      required this.onDiscover,
      required this.onOpen});
  final RentalController controller;
  final VoidCallback onDiscover;
  final ValueChanged<RentalVehicle> onOpen;
  @override
  State<RentalPlansScreen> createState() => _RentalPlansScreenState();
}

class _RentalPlansScreenState extends State<RentalPlansScreen> {
  String _filter = 'all';
  Future<void> _cancel(LocalReservation record) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
                scrollable: true,
                title: const Text('Bu planı iptal edelim mi?'),
                content: const Text(
                    'Cihazınızdaki kayıt iptal edildi olarak saklanır. Tarihler yeniden açılır. Ödeme veya iade yapılmaz.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Vazgeç')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Evet, iptal et'))
                ]));
    if (confirm == true && mounted) {
      await rentalAction(context, () => widget.controller.cancel(record.id));
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller;
        final data = state.repository.data;
        final records = data.plans
            .where((r) =>
                _filter == 'all' ||
                (_filter == 'cancelled' ? r.cancelled : !r.cancelled))
            .toList();
        return StudioPage(children: [
          PageHeading(
              eyebrow: 'Yolculuklarınız',
              title: 'Rezervasyonlarım',
              description:
                  'Tarihleriniz, seçtiğiniz araçlar ve tüm yolculuk planlarınız.',
              action: OutlinedButton.icon(
                  onPressed: widget.onDiscover,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Yeni rezervasyon'))),
          const SizedBox(height: 24),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final f in [
              ('all', 'Tümü (${data.plans.length})'),
              (
                'active',
                'Planlanan (${data.plans.where((r) => !r.cancelled).length})'
              ),
              ('cancelled', 'İptal edilen')
            ])
              ChoiceChip(
                  label: Text(f.$2),
                  selected: _filter == f.$1,
                  onSelected: (_) => setState(() => _filter = f.$1)),
          ]),
          const SizedBox(height: 24),
          if (records.isEmpty) ...[
            StudioPanel(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Icon(Icons.route_outlined,
                      size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                      data.plans.isEmpty
                          ? 'İlk yolculuğunuz buradan başlasın.'
                          : 'Bu listede henüz bir plan yok.',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text(
                      'Aracınızı seçin, tarihlerinizi belirleyin. Kaydettiğiniz planlar burada görünsün.'),
                  const SizedBox(height: 18),
                  FilledButton(
                      onPressed: widget.onDiscover,
                      child: const Text('Araçları keşfet')),
                ])),
            const SizedBox(height: 28),
            Text('Bir sonraki rotanız için',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            RentalCarGrid(
                vehicles: state.repository.catalog.take(3).toList(),
                favorites: data.favorites,
                onOpen: widget.onOpen,
                onFavorite: !state.ready || state.busy
                    ? null
                    : (v) => rentalAction(context, () => state.favorite(v.id))),
          ] else
            for (final record in records)
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RentalPlanCard(
                      record: record,
                      vehicle: state.repository.vehicle(record.vehicleId),
                      onCancel: state.busy || !state.ready
                          ? null
                          : () => _cancel(record))),
        ]);
      });
}
