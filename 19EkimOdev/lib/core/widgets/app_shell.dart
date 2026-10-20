import 'package:flutter/material.dart';

import '../../data/demo/demo_clinic_store.dart';
import '../../data/models/collection_status.dart';
import '../../features/dashboard/views/dashboard_view.dart';
import '../../features/patient_intake/views/patient_intake_view.dart';
import '../../features/queue_management/controllers/queue_controller.dart';
import '../../features/queue_management/controllers/visit_actions.dart';
import '../../features/queue_management/views/queue_view.dart';
import '../../features/sample_tracking/views/sample_tracking_view.dart';
import '../../features/settings/views/settings_view.dart';
import '../theme/theme_controller.dart';

/// VenaFlow ana kabuk widget'ı.
///
/// Material 3 tabanlı mobil alt gezinme çubuğu (ve geniş ekranda NavigationRail)
/// ile 5 temel modülü birbirine bağlar:
/// 1. Dashboard (Gösterge Paneli)
/// 2. Kan Alma Sırası
/// 3. Hasta Kabul
/// 4. Numune Takibi
/// 5. Ayarlar ve Sistem
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.store,
    required this.themeController,
  });

  final DemoClinicStore store;
  final ThemeController themeController;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;
  late final VisitActions _actions;
  late final QueueController _queueController;

  @override
  void initState() {
    super.initState();
    _actions = VisitActions(widget.store);
    _queueController = QueueController();
  }

  @override
  void dispose() {
    _queueController.dispose();
    super.dispose();
  }

  void _navigateToQueue(CollectionStatus? status) {
    _queueController.setFilter(status);
    setState(() => _currentIndex = 1);
  }

  void _navigateToPatientIntake() {
    setState(() => _currentIndex = 2);
  }

  void _toggleTheme() {
    final ThemeMode current = widget.themeController.mode.value;
    final ThemeMode next = switch (current) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    widget.themeController.setMode(next);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final List<Widget> pages = <Widget>[
      DashboardView(
        store: widget.store,
        actions: _actions,
        onNewPatient: _navigateToPatientIntake,
        onOpenQueue: _navigateToQueue,
      ),
      QueueView(
        store: widget.store,
        controller: _queueController,
        actions: _actions,
      ),
      PatientIntakeView(
        store: widget.store,
        onCreated: (visit) {
          _queueController.clear();
          setState(() => _currentIndex = 1);
        },
      ),
      SampleTrackingView(
        store: widget.store,
        actions: _actions,
      ),
      SettingsView(
        store: widget.store,
        themeController: widget.themeController,
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= 840;

        final PreferredSizeWidget appBar = AppBar(
          titleSpacing: 16,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.bloodtype_rounded,
                  color: scheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'VenaFlow',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'DEMO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ValueListenableBuilder<bool>(
              valueListenable: widget.store.canUndo,
              builder: (BuildContext context, bool canUndo, _) {
                if (!canUndo) return const SizedBox.shrink();
                return IconButton(
                  tooltip: 'Son İşlemi Geri Al',
                  icon: const Icon(Icons.undo_rounded),
                  onPressed: () {
                    if (widget.store.undo()) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Son işlem geri alındı.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                    }
                  },
                );
              },
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: widget.themeController.mode,
              builder: (BuildContext context, ThemeMode mode, _) {
                return IconButton(
                  tooltip: 'Tema Değiştir (${mode.label})',
                  icon: Icon(mode.icon),
                  onPressed: _toggleTheme,
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        );

        if (isWide) {
          return Scaffold(
            appBar: appBar,
            body: Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) =>
                      setState(() => _currentIndex = index),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FloatingActionButton.small(
                      heroTag: 'quick_intake_fab',
                      tooltip: 'Yeni Hasta Kabulü',
                      onPressed: _navigateToPatientIntake,
                      child: const Icon(Icons.add_rounded),
                    ),
                  ),
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.format_list_numbered_rounded),
                      selectedIcon: Icon(Icons.format_list_numbered_rtl_rounded),
                      label: Text('Sıra'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_add_outlined),
                      selectedIcon: Icon(Icons.person_add_rounded),
                      label: Text('Kabul'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.science_outlined),
                      selectedIcon: Icon(Icons.science_rounded),
                      label: Text('Numuneler'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings_rounded),
                      label: Text('Ayarlar'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: pages,
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: _currentIndex == 2 ? null : appBar,
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (int index) =>
                setState(() => _currentIndex = index),
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.format_list_numbered_rounded),
                selectedIcon: Icon(Icons.format_list_numbered_rtl_rounded),
                label: 'Sıra',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_add_outlined),
                selectedIcon: Icon(Icons.person_add_rounded),
                label: 'Kabul',
              ),
              NavigationDestination(
                icon: Icon(Icons.science_outlined),
                selectedIcon: Icon(Icons.science_rounded),
                label: 'Numune',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Ayarlar',
              ),
            ],
          ),
        );
      },
    );
  }
}
