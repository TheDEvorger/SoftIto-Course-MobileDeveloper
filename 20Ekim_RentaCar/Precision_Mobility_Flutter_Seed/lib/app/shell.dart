import 'package:flutter/material.dart';
import '../features/discovery/presentation/discovery_screen.dart';
import '../features/fleet/presentation/fleet_workspace_screen.dart';
import '../features/bookings/presentation/bookings_screen.dart';
import '../features/garage/presentation/garage_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell(
      {super.key, required this.themeMode, required this.onThemeChanged});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  static const destinations = [
    NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Keşfet'),
    NavigationDestination(
        icon: Icon(Icons.directions_car_outlined), label: 'Araçlar'),
    NavigationDestination(
        icon: Icon(Icons.event_note_outlined), label: 'Sürüşlerim'),
    NavigationDestination(icon: Icon(Icons.person_outline), label: 'Hesabım'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DiscoveryScreen(),
      const GarageScreen(workspace: FleetWorkspaceScreen()),
      const BookingsScreen(),
      ProfileScreen(
          themeMode: widget.themeMode, onThemeChanged: widget.onThemeChanged),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 840;
      final body = IndexedStack(index: _index, children: pages);
      return Scaffold(
        appBar: AppBar(
          title: const Text('PRECISION / MOBILITY',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6)),
          actions: const [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                    child: Text('DEMO', style: TextStyle(letterSpacing: 2))))
          ],
        ),
        body: wide
            ? Row(children: [
                NavigationRail(
                  extended: constraints.maxWidth >= 1120,
                  selectedIndex: _index,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  labelType: constraints.maxWidth >= 1120
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.explore_outlined),
                        label: Text('Keşfet')),
                    NavigationRailDestination(
                        icon: Icon(Icons.directions_car_outlined),
                        label: Text('Araçlar')),
                    NavigationRailDestination(
                        icon: Icon(Icons.event_note_outlined),
                        label: Text('Sürüşlerim')),
                    NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        label: Text('Hesabım')),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ])
            : body,
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: (value) =>
                    setState(() => _index = value),
                destinations: destinations,
              ),
      );
    });
  }
}
