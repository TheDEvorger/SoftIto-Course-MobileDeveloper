import 'package:flutter/material.dart';

class RentalShell extends StatelessWidget {
  const RentalShell(
      {super.key,
      required this.pages,
      required this.index,
      required this.onSelected,
      required this.loading,
      required this.onRetry,
      this.error});
  final List<Widget> pages;
  final int index;
  final bool loading;
  final String? error;
  final ValueChanged<int> onSelected;
  final VoidCallback onRetry;
  static const items = [
    (Icons.explore_outlined, 'Keşfet'),
    (Icons.favorite_border, 'Favoriler'),
    (Icons.calendar_month_outlined, 'Planlarım'),
    (Icons.person_outline, 'Profil')
  ];
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth >= 1000 &&
            MediaQuery.textScalerOf(context).scale(1) < 1.4;
        final colors = Theme.of(context).colorScheme;
        return Scaffold(
            body: SafeArea(
                child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      color: colors.surface,
                      border: Border(
                          bottom: BorderSide(color: colors.outlineVariant))),
                  child: Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Row(children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: colors.primary,
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    child: Icon(Icons.route_rounded,
                                        color: colors.onPrimary, size: 23)),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text('PRECISION',
                                          style: TextStyle(
                                              fontSize: 15,
                                              letterSpacing: 2,
                                              fontWeight: FontWeight.w700,
                                              color: colors.onSurface)),
                                      Text('ARAÇ KİRALAMA',
                                          style: TextStyle(
                                              fontSize: 8,
                                              letterSpacing: 1.6,
                                              color: colors.onSurfaceVariant)),
                                    ])),
                                if (wide)
                                  for (var i = 0; i < items.length; i++)
                                    Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: TextButton.icon(
                                            onPressed: () => onSelected(i),
                                            style: TextButton.styleFrom(
                                                backgroundColor: i == index
                                                    ? colors.primaryContainer
                                                    : null),
                                            icon: Icon(items[i].$1, size: 18),
                                            label: Text(items[i].$2))),
                                if (!wide)
                                  IconButton(
                                      onPressed: () => onSelected(2),
                                      tooltip: 'Rezervasyonlarım',
                                      icon: const Icon(
                                          Icons.event_available_outlined)),
                              ]))))),
              if (loading) const LinearProgressIndicator(),
              if (error != null)
                Container(
                    color: colors.errorContainer,
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      Expanded(
                          child: Text(error!,
                              style:
                                  TextStyle(color: colors.onErrorContainer))),
                      IconButton(
                          onPressed: onRetry,
                          tooltip: 'Cihaz kayıtlarını yeniden yükle',
                          icon: const Icon(Icons.refresh))
                    ])),
              Expanded(child: IndexedStack(index: index, children: pages)),
            ])),
            bottomNavigationBar: wide
                ? null
                : SafeArea(
                    top: false,
                    child: NavigationBar(
                        selectedIndex: index,
                        onDestinationSelected: onSelected,
                        labelBehavior: c.maxWidth < 370 ||
                                MediaQuery.textScalerOf(context).scale(1) > 1.3
                            ? NavigationDestinationLabelBehavior
                                .onlyShowSelected
                            : NavigationDestinationLabelBehavior.alwaysShow,
                        destinations: [
                          for (final item in items)
                            NavigationDestination(
                                icon: Icon(item.$1),
                                label: item.$2,
                                tooltip: item.$2)
                        ])));
      });
}
