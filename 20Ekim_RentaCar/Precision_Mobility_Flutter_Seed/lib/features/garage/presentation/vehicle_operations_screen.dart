import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../../discovery/domain/vehicle.dart';
import '../application/vehicle_operations_controller.dart';

class VehicleOperationsScreen extends StatefulWidget {
  const VehicleOperationsScreen(
      {super.key, required this.api, required this.vehicle});
  final ApiClient api;
  final Vehicle vehicle;
  @override
  State<VehicleOperationsScreen> createState() =>
      _VehicleOperationsScreenState();
}

class _VehicleOperationsScreenState extends State<VehicleOperationsScreen> {
  late final _state = VehicleOperationsController(widget.api, widget.vehicle)
    ..load();
  String _reason = 'Planlı bakım';
  @override
  void initState() {
    super.initState();
    _state;
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  Future<void> _block() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final range = await showDateRangePicker(
        context: context,
        firstDate: today,
        lastDate: today.add(const Duration(days: 365)),
        helpText: 'Kapatılacak tarihler',
        saveText: 'Seç');
    if (range == null || !mounted) return;
    await _state.block(range.start, range.end, _reason);
  }

  String _dates(Map<String, dynamic> item) {
    final dates = MaterialLocalizations.of(context);
    return '${dates.formatShortDate(DateTime.parse(item['starts_on'] as String))} — '
        '${dates.formatShortDate(DateTime.parse(item['ends_on'] as String))}';
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: _state,
      builder: (context, _) => PopScope(
          canPop: !_state.busy,
          child: Scaffold(
              appBar: AppBar(title: const Text('Takvim ve yayın')),
              body: StudioPage(width: 1000, children: [
                PageHeading(
                    eyebrow: 'Envanter / Müsaitlik',
                    title: widget.vehicle.name,
                    description:
                        'Yayın durumunu ve kiralamaya kapalı günleri yönetin. '
                        'Tarih aralıkları dönüş gününü içermez; her kayıt 1–7 gün olabilir.'),
                const SizedBox(height: 24),
                StudioPanel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Keşfet koleksiyonunda yayınla'),
                          subtitle: Text(_state.published
                              ? 'Yayın açık. Bakımdaki araçlar keşfette gösterilmez.'
                              : 'Yayın kapalı. Araç ve rezervasyon geçmişi korunuyor.'),
                          value: _state.published,
                          onChanged: _state.busy ? null : _state.publish),
                      const Divider(height: 32),
                      Text('Yeni kapalı tarih',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                          initialValue: _reason,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Kapatma nedeni'),
                          items: [
                            for (final reason in [
                              'Planlı bakım',
                              'Kişisel kullanım',
                              'Operasyon hazırlığı'
                            ])
                              DropdownMenuItem(
                                  value: reason, child: Text(reason))
                          ],
                          onChanged: _state.busy
                              ? null
                              : (v) => setState(() => _reason = v!)),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                          onPressed: _state.busy ? null : _block,
                          icon: const Icon(Icons.event_busy_outlined),
                          label: const Text('Tarih aralığını kapat')),
                      if (_state.busy)
                        const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: LinearProgressIndicator()),
                      if (_state.error != null)
                        Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Semantics(
                                liveRegion: true,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_state.error!,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error)),
                                      TextButton(
                                          onPressed:
                                              _state.busy ? null : _state.load,
                                          child: const Text('Takvimi yenile'))
                                    ]))),
                    ])),
                const SizedBox(height: 24),
                StudioPanel(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Müsaitlik takvimi',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      const Text(
                          'Rezervasyonlu veya kapalı günlerde yeni kayıt alınmaz.'),
                      const SizedBox(height: 20),
                      if (_state.blocks.isEmpty &&
                          _state.reservations.isEmpty &&
                          !_state.busy &&
                          _state.error == null)
                        const ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.event_available_outlined),
                            title: Text('Takvim açık'),
                            subtitle: Text(
                                'Kayıtlı rezervasyon veya kapalı tarih yok.')),
                      for (final booking in _state.reservations)
                        ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.event_note_outlined),
                            title: Text(_dates(booking)),
                            subtitle: const Text('Rezerve edildi')),
                      for (final block in _state.blocks)
                        Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading:
                                          const Icon(Icons.event_busy_outlined),
                                      title: Text(_dates(block)),
                                      subtitle:
                                          Text(block['reason'] as String)),
                                  OutlinedButton.icon(
                                      onPressed: _state.busy
                                          ? null
                                          : () => _state
                                              .release(block['id'] as String),
                                      icon: const Icon(Icons.lock_open_outlined,
                                          size: 16),
                                      label:
                                          const Text('Tarihleri yeniden aç')),
                                ])),
                    ])),
              ]))));
}
