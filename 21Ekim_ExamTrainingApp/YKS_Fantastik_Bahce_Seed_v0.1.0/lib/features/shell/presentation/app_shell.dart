import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../../analytics/presentation/analytics_screen.dart';
import '../../exams/presentation/exams_screen.dart';
import '../../focus/presentation/focus_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../topics/presentation/topics_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  void openFocus() => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const FocusScreen()),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = <Widget>[
      HomeScreen(onStartFocus: openFocus),
      const TopicsScreen(),
      const ExamsScreen(),
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    const destinations = <NavigationDestination>[
      NavigationDestination(
        icon: Icon(Icons.yard_outlined),
        selectedIcon: Icon(Icons.yard, color: Colors.white),
        label: 'Ana Sayfa',
      ),
      NavigationDestination(
        icon: Icon(Icons.auto_stories_outlined),
        selectedIcon: Icon(Icons.auto_stories, color: Colors.white),
        label: 'Konular',
      ),
      NavigationDestination(
        icon: Icon(Icons.fact_check_outlined),
        selectedIcon: Icon(Icons.fact_check, color: Colors.white),
        label: 'Denemeler',
      ),
      NavigationDestination(
        icon: Icon(Icons.insights_outlined),
        selectedIcon: Icon(Icons.insights, color: Colors.white),
        label: 'Analiz',
      ),
      NavigationDestination(
        icon: Icon(Icons.account_circle_outlined),
        selectedIcon: Icon(Icons.account_circle, color: Colors.white),
        label: 'Profil',
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 760;
      final body = IndexedStack(index: selectedIndex, children: pages);

      if (isWide) {
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: GardenPalette.mossEmerald,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.eco,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 12),
                        IconButton.filled(
                          onPressed: openFocus,
                          icon: const Icon(Icons.timer_outlined),
                          tooltip: 'Odak Odası',
                          style: IconButton.styleFrom(
                            backgroundColor: GardenPalette.peachCoral,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  indicatorColor: GardenPalette.mossEmerald,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.yard_outlined),
                      selectedIcon: Icon(Icons.yard, color: Colors.white),
                      label: Text('Ana Sayfa'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_stories_outlined),
                      selectedIcon:
                          Icon(Icons.auto_stories, color: Colors.white),
                      label: Text('Konular'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.fact_check_outlined),
                      selectedIcon: Icon(Icons.fact_check, color: Colors.white),
                      label: Text('Denemeler'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights, color: Colors.white),
                      label: Text('Analiz'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.account_circle_outlined),
                      selectedIcon:
                          Icon(Icons.account_circle, color: Colors.white),
                      label: Text('Profil'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        body: SafeArea(child: body),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => selectedIndex = index),
          backgroundColor: isDark
              ? GardenPalette.nightBackdrop
              : GardenPalette.sandyPorcelain,
          indicatorColor: GardenPalette.mossEmerald,
          elevation: 4,
          destinations: destinations,
        ),
      );
    });
  }
}
