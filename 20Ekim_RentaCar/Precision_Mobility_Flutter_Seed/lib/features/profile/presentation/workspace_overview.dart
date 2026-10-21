import 'package:flutter/material.dart';
import '../../../shared/design/studio_page.dart';
import '../../bookings/application/reservation_controller.dart';
import '../../discovery/application/catalog_controller.dart';

class WorkspaceOverview extends StatelessWidget {
  const WorkspaceOverview(
      {super.key, required this.inventory, required this.reservations});
  final CatalogController inventory;
  final ReservationController reservations;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Listenable.merge([inventory, reservations]),
        builder: (context, _) => StudioPanel(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Çalışma alanına genel bakış',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 18),
          if (inventory.loading || reservations.loading)
            const LinearProgressIndicator()
          else if (inventory.error != null || reservations.error != null)
            Text(inventory.error ?? reservations.error!)
          else
            Wrap(spacing: 28, runSpacing: 20, children: [
              for (final metric in [
                ('${inventory.vehicles.length}', 'Kayıtlı araç'),
                (
                  '${inventory.vehicles.where((v) => v.published && !v.inMaintenance).length}',
                  'Yayında'
                ),
                (
                  '${reservations.records.where((r) => !r.cancelled).length}',
                  'Rezervasyon'
                ),
                (
                  '${reservations.records.where((r) => r.cancelled).length}',
                  'İptal kaydı'
                ),
              ])
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(metric.$1,
                      style: Theme.of(context).textTheme.headlineMedium),
                  Text(metric.$2, style: Theme.of(context).textTheme.bodySmall),
                ]),
            ]),
        ])),
      );
}
