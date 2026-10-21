import 'package:flutter/material.dart';
import '../../../shared/design/action_state.dart';
import '../../../shared/design/studio_page.dart';
import '../application/catalog_controller.dart';
import '../domain/vehicle.dart';
import 'catalog_vehicle_card.dart';
import 'editorial_hero.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen(
      {super.key,
      required this.controller,
      required this.onOpen,
      required this.onAddVehicle});
  final CatalogController controller;
  final void Function(Vehicle, DateTimeRange?) onOpen;
  final VoidCallback onAddVehicle;
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _resultsKey = GlobalKey();
  String _query = '', _source = 'all', _sort = 'name';
  DateTimeRange? _dates;

  Future<void> _reload() =>
      widget.controller.load(start: _dates?.start, end: _dates?.end);
  Future<void> _pickDates() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final range = await showDateRangePicker(
        context: context,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
        initialDateRange: _dates,
        helpText: 'Alış ve dönüş tarihleri',
        saveText: 'Uygula');
    if (!mounted || range == null) return;
    if (rentalDays(range.start, range.end) < 1 ||
        rentalDays(range.start, range.end) > 7) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('1–7 günlük bir tarih aralığı seçin.')));
      return;
    }
    setState(() => _dates = range);
    await _reload();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller;
        final filtered = state.vehicles
            .where((v) =>
                '${v.name} ${v.category} ${v.energy}'
                    .toLowerCase()
                    .contains(_query.toLowerCase().trim()) &&
                (_source == 'all' || v.ownership == _source))
            .toList();
        filtered.sort((a, b) => _sort == 'low'
            ? a.rateMinor.compareTo(b.rateMinor)
            : _sort == 'high'
                ? b.rateMinor.compareTo(a.rateMinor)
                : a.name.compareTo(b.name));
        return StudioPage(children: [
          EditorialHero(
              onExplore: () => Scrollable.ensureVisible(
                  _resultsKey.currentContext!,
                  duration: const Duration(milliseconds: 350),
                  alignment: .1)),
          const SizedBox(height: 24),
          StudioPanel(
              padding: 20,
              child: LayoutBuilder(builder: (context, constraints) {
                final search = TextField(
                    decoration: const InputDecoration(
                        labelText: 'Araç, kategori veya enerji türü ara',
                        prefixIcon: Icon(Icons.search)),
                    onChanged: (value) => setState(() => _query = value));
                final dates = OutlinedButton.icon(
                    onPressed: _pickDates,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(_dates == null
                        ? 'Tarih seç'
                        : '${dateKey(_dates!.start)} → ${dateKey(_dates!.end)}'));
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (constraints.maxWidth >= 760 &&
                          MediaQuery.textScalerOf(context).scale(1) < 1.4)
                        Row(children: [
                          Expanded(child: search),
                          const SizedBox(width: 20),
                          dates
                        ])
                      else ...[search, const SizedBox(height: 12), dates],
                      if (_dates != null)
                        Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                                onPressed: () {
                                  setState(() => _dates = null);
                                  _reload();
                                },
                                child: const Text('Tarihleri temizle'))),
                    ]);
              })),
          const SizedBox(height: 36),
          Container(
              key: _resultsKey,
              child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 16,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KOLEKSİYON',
                              style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          const SizedBox(height: 8),
                          Text('Sürüşünüzü seçin.',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          if (!state.loading && state.error == null)
                            Text('${filtered.length} araç',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant)),
                        ]),
                    LayoutBuilder(
                        builder: (context, constraints) => SizedBox(
                            width: constraints.maxWidth.clamp(0.0, 280.0),
                            child: Row(children: [
                              Expanded(
                                  child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: _sort,
                                      underline: const SizedBox.shrink(),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'name',
                                            child: Text('Ada göre',
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        DropdownMenuItem(
                                            value: 'low',
                                            child: Text('Fiyat: düşükten',
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        DropdownMenuItem(
                                            value: 'high',
                                            child: Text('Fiyat: yüksekten',
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis))
                                      ],
                                      onChanged: (value) =>
                                          setState(() => _sort = value!))),
                              const SizedBox(width: 8),
                              IconButton(
                                  onPressed: state.loading ? null : _reload,
                                  tooltip: 'Araçları yenile',
                                  icon: const Icon(Icons.refresh)),
                            ]))),
                  ])),
          const SizedBox(height: 20),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final filter in const [
              ('all', 'Tümü'),
              ('fleet', 'Filo'),
              ('private', 'Bireysel')
            ])
              ChoiceChip(
                  label: Text(filter.$2),
                  selected: _source == filter.$1,
                  onSelected: (_) => setState(() => _source = filter.$1)),
          ]),
          const SizedBox(height: 24),
          if (state.loading)
            const LinearProgressIndicator(semanticsLabel: 'Araçlar yükleniyor')
          else if (state.error != null)
            ActionState(
                title: 'Bağlantıyı yeniden kuralım.',
                message: state.error!,
                icon: Icons.wifi_off_outlined,
                action: _reload,
                label: 'Yeniden dene')
          else if (filtered.isEmpty)
            ActionState(
                title: state.vehicles.isEmpty && _dates == null
                    ? 'İlk yolculuk, ilk araçla başlar.'
                    : 'Bu seçimde uygun araç yok.',
                message: _dates == null
                    ? 'Kendi araç kayıtlarınızı ekleyin. Yayındaki araçlar bu koleksiyonda görünsün.'
                    : 'Tarihlerinizi veya araç kaynağını değiştirerek tekrar arayabilirsiniz.',
                icon: Icons.directions_car_outlined,
                action: widget.onAddVehicle,
                label: 'Araç ekle')
          else
            CatalogGrid(
                vehicles: filtered, onOpen: (v) => widget.onOpen(v, _dates)),
          const SizedBox(height: 36),
          const Divider(),
          const SizedBox(height: 20),
          Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 24,
              runSpacing: 18,
              children: [
                _note(context, Icons.calendar_month_outlined,
                    'Tarihinizi seçin', 'Veritabanından güncel müsaitlik.'),
                _note(
                    context,
                    Icons.compare_arrows_rounded,
                    'Seçenekleri karşılaştırın',
                    'Bireysel ve filo araçları bir arada.'),
                _note(context, Icons.route_outlined, 'Planınızı yönetin',
                    'Rezervasyon ve iptal kayıtlarına erişin.'),
              ]),
        ]);
      });

  Widget _note(
          BuildContext context, IconData icon, String title, String message) =>
      SizedBox(
          width: 290,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 23, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text(message,
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ])),
          ]));
}
