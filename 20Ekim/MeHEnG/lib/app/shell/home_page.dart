import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/ventures/ventures.dart';
import '../theme/theme_provider.dart';
import 'module_preview.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selected = 0;
  static const labels = ['Girişimler', 'Keşfet', 'Topluluk', 'Büyüme'];
  static const icons = [
    Icons.dashboard_outlined,
    Icons.science_outlined,
    Icons.groups_outlined,
    Icons.trending_up_outlined,
  ];
  static const selectedIcons = [
    Icons.dashboard,
    Icons.science,
    Icons.groups,
    Icons.trending_up,
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = selected == 0
        ? const VentureOverview()
        : ModulePreview(index: selected);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MeHEnG',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                'Fikirden kanıta',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          IconButton(
            tooltip: isDark ? 'Açık temaya geç' : 'Koyu temaya geç',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle(isDark);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  extended: MediaQuery.sizeOf(context).width >= 1100,
                  selectedIndex: selected,
                  onDestinationSelected: (i) => setState(() => selected = i),
                  destinations: [
                    for (var i = 0; i < labels.length; i++)
                      NavigationRailDestination(
                        icon: Icon(icons[i]),
                        selectedIcon: Icon(selectedIcons[i]),
                        label: Text(labels[i]),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            )
          : content,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (i) => setState(() => selected = i),
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationDestination(
                    icon: Icon(icons[i]),
                    selectedIcon: Icon(selectedIcons[i]),
                    label: labels[i],
                  ),
              ],
            ),
    );
  }
}
