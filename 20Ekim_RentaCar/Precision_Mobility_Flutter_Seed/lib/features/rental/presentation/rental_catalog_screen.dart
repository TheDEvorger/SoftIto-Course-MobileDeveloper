import 'package:flutter/material.dart';
import '../../../shared/design/page_heading.dart';
import '../../../shared/design/studio_page.dart';
import '../application/rental_controller.dart';
import '../domain/rental_vehicle.dart';
import 'rental_actions.dart';
import 'rental_car_card.dart';
import 'rental_hero.dart';

class RentalCatalogScreen extends StatefulWidget {
  const RentalCatalogScreen(
      {super.key,
      required this.controller,
      required this.onOpen,
      this.favoritesOnly = false});
  final RentalController controller;
  final void Function(RentalVehicle, DateTimeRange?) onOpen;
  final bool favoritesOnly;
  @override
  State<RentalCatalogScreen> createState() => _RentalCatalogScreenState();
}

class _RentalCatalogScreenState extends State<RentalCatalogScreen> {
  String _query = '', _category = 'Tümü', _sort = 'collection';
  DateTimeRange? _dates;
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _chooseDates() async {
    final dates = await rentalDates(context, initial: _dates);
    if (dates == null || !mounted) return;
    final days = calendarDays(dates.start, dates.end);
    if (days < 1 || days > 7) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('1–7 günlük bir tarih aralığı seçin.')));
      return;
    }
    setState(() => _dates = dates);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller;
        final data = state.repository.data;
        final emptyFavorites = widget.favoritesOnly && data.favorites.isEmpty;
        final list = state.repository.catalog.where((v) {
          final matches = '${v.name} ${v.category} ${v.energy} ${v.city}'
              .toLowerCase()
              .contains(_query.toLowerCase());
          return matches &&
              (_category == 'Tümü' || v.category == _category) &&
              (widget.favoritesOnly
                  ? emptyFavorites || data.favorites.contains(v.id)
                  : data.city == 'Tüm şehirler' || v.city == data.city) &&
              (_dates == null ||
                  state.repository.available(v.id, _dates!.start, _dates!.end));
        }).toList();
        if (_sort == 'low') {
          list.sort((a, b) => a.dailyMinor.compareTo(b.dailyMinor));
        }
        if (_sort == 'high') {
          list.sort((a, b) => b.dailyMinor.compareTo(a.dailyMinor));
        }
        if (emptyFavorites && list.length > 3) list.removeRange(3, list.length);
        final localizations = MaterialLocalizations.of(context);
        return StudioPage(children: [
          if (!widget.favoritesOnly)
            const RentalHero()
          else
            const PageHeading(
                eyebrow: 'Koleksiyonunuz',
                title: 'Gözünüzün kaldığı araçlar.',
                description:
                    'Kalbine dokunun, favorilerinize ekleyin. Seçtikleriniz burada sizi beklesin.'),
          const SizedBox(height: 24),
          if (emptyFavorites) ...[
            const StudioPanel(
                child: Text(
                    'Henüz bir favoriniz yok. Başlamak için koleksiyondan üç seçenek hazırladık.')),
            const SizedBox(height: 20),
          ],
          StudioPanel(
              padding: 16,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                        controller: _search,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                            labelText: 'Hangi aracı arıyorsunuz?',
                            hintText: 'Marka, model veya kategori',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Aramayı temizle',
                                    onPressed: () {
                                      _search.clear();
                                      setState(() => _query = '');
                                    },
                                    icon: const Icon(Icons.close)))),
                    if (!widget.favoritesOnly) ...[
                      const SizedBox(height: 12),
                      LayoutBuilder(builder: (context, c) {
                        final city = DropdownButtonFormField<String>(
                            key: ValueKey(data.city),
                            initialValue: data.city,
                            isExpanded: true,
                            decoration: const InputDecoration(
                                labelText: 'Alış şehri',
                                prefixIcon: Icon(Icons.location_on_outlined)),
                            items: [
                              for (final city in [
                                'Tüm şehirler',
                                'İstanbul',
                                'Ankara',
                                'İzmir'
                              ])
                                DropdownMenuItem(value: city, child: Text(city))
                            ],
                            onChanged: !state.ready || state.busy
                                ? null
                                : (v) => rentalAction(
                                    context, () => state.preferences(city: v)));
                        final date = OutlinedButton.icon(
                            onPressed: _chooseDates,
                            icon: const Icon(Icons.calendar_month_outlined,
                                size: 18),
                            label: Text(_dates == null
                                ? 'Alış ve dönüş tarihi'
                                : '${localizations.formatShortDate(_dates!.start)} — ${localizations.formatShortDate(_dates!.end)}'));
                        return c.maxWidth < 650 ||
                                MediaQuery.textScalerOf(context).scale(1) > 1.3
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                    city,
                                    const SizedBox(height: 12),
                                    date
                                  ])
                            : Row(children: [
                                Expanded(child: city),
                                const SizedBox(width: 16),
                                Expanded(child: date)
                              ]);
                      }),
                    ],
                    if (_dates != null)
                      Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                              onPressed: () => setState(() => _dates = null),
                              icon: const Icon(Icons.close, size: 16),
                              label: const Text('Tarih filtresini kaldır'))),
                  ])),
          const SizedBox(height: 22),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final category in [
                  'Tümü',
                  'Ekonomik',
                  'Konfor',
                  'SUV',
                  'Elektrikli',
                  'Premium'
                ])
                  Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                          label: Text(category),
                          selected: _category == category,
                          onSelected: (_) =>
                              setState(() => _category = category))),
              ])),
          const SizedBox(height: 24),
          LayoutBuilder(
              builder: (context, c) => Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 16,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                            '${list.length} araç${emptyFavorites ? ' önerisi' : ''}',
                            style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(
                            width: c.maxWidth.clamp(0, 230),
                            child: DropdownButtonFormField<String>(
                                initialValue: _sort,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: 'Sıralama'),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'collection',
                                      child: Text('Koleksiyon sırası')),
                                  DropdownMenuItem(
                                      value: 'low',
                                      child: Text('Fiyat: artan')),
                                  DropdownMenuItem(
                                      value: 'high',
                                      child: Text('Fiyat: azalan'))
                                ],
                                onChanged: (v) => setState(() => _sort = v!))),
                      ])),
          const SizedBox(height: 20),
          if (list.isEmpty)
            StudioPanel(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Bu seçimle eşleşen araç yok.',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text('Aramayı, kategoriyi veya tarihleri değiştirin.'),
                  const SizedBox(height: 16),
                  OutlinedButton(
                      onPressed: () {
                        _search.clear();
                        setState(() {
                          _query = '';
                          _category = 'Tümü';
                          _dates = null;
                        });
                        if (!widget.favoritesOnly) {
                          rentalAction(context,
                              () => state.preferences(city: 'Tüm şehirler'));
                        }
                      },
                      child: const Text('Filtreleri temizle')),
                ]))
          else
            RentalCarGrid(
                vehicles: list,
                favorites: data.favorites,
                onOpen: (v) => widget.onOpen(v, _dates),
                onFavorite: !state.ready || state.busy
                    ? null
                    : (v) => rentalAction(context, () => state.favorite(v.id))),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                  'Hazır koleksiyon · Araç bilgileri ve fiyatlar örnektir. Planlar bu cihazda saklanır.',
                  style: TextStyle(fontSize: 11))),
        ]);
      });
}
