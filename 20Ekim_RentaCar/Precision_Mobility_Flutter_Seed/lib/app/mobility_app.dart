import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/network/api_client.dart';
import '../core/theme/studio_theme.dart';
import '../features/bookings/application/reservation_controller.dart';
import '../features/bookings/presentation/reservations_screen.dart';
import '../features/bookings/presentation/reserve_vehicle_screen.dart';
import '../features/discovery/application/catalog_controller.dart';
import '../features/discovery/domain/vehicle.dart';
import '../features/discovery/presentation/catalog_screen.dart';
import '../features/garage/presentation/inventory_screen.dart';
import '../features/garage/presentation/vehicle_editor_screen.dart';
import '../features/garage/presentation/vehicle_operations_screen.dart';
import '../features/profile/presentation/workspace_screen.dart';
import 'mobility_shell.dart';

class MobilityApp extends StatefulWidget {
  const MobilityApp(
      {super.key,
      this.api,
      this.initialExamples = const bool.fromEnvironment('PRECISION_EXAMPLES',
          defaultValue: true)});
  final ApiClient? api;
  final bool initialExamples;
  @override
  State<MobilityApp> createState() => _MobilityAppState();
}

class _MobilityAppState extends State<MobilityApp> {
  late final ApiClient _api;
  late final CatalogController _catalog, _inventory;
  late final ReservationController _reservations;
  ThemeMode _theme = ThemeMode.system;
  int _index = 0;
  bool _switching = false;
  String? _sessionError;
  @override
  void initState() {
    super.initState();
    _api = widget.api ??
        ApiClient(
            baseUri: Uri.parse(const String.fromEnvironment('PRECISION_API_URL',
                defaultValue: 'http://127.0.0.1:8765/api/v1/')));
    _catalog = CatalogController(_api);
    _inventory = CatalogController(_api);
    _reservations = ReservationController(_api);
    if (widget.initialExamples) {
      _openExamples();
    } else {
      _catalog.load();
    }
  }

  @override
  void dispose() {
    _catalog.dispose();
    _inventory.dispose();
    _reservations.dispose();
    if (widget.api == null) _api.close();
    super.dispose();
  }

  void _sessionChanged() {
    _catalog.clear();
    _inventory.clear();
    _reservations.clear();
    _catalog.load();
    if (_api.authenticated) {
      _inventory.load(workspace: true);
      _reservations.load();
    }
    setState(() {});
  }

  Future<void> _openExamples() async {
    setState(() {
      _switching = true;
      _sessionError = null;
    });
    try {
      await _api.openExamples();
      if (mounted) _sessionChanged();
    } catch (error) {
      if (mounted) setState(() => _sessionError = error.toString());
    } finally {
      if (mounted) setState(() => _switching = false);
    }
  }

  Future<void> _edit(BuildContext context, Vehicle? vehicle) async {
    final saved = await Navigator.of(context).push<bool>(MaterialPageRoute(
        builder: (_) =>
            VehicleEditorScreen(controller: _inventory, vehicle: vehicle)));
    if (saved == true && mounted) {
      await Future.wait([_inventory.load(workspace: true), _catalog.refresh()]);
    }
  }

  Future<void> _open(
      BuildContext context, Vehicle v, DateTimeRange? dates) async {
    await Navigator.of(context).push<void>(MaterialPageRoute(
        builder: (_) => ReserveVehicleScreen(
            vehicle: v,
            controller: _reservations,
            connected: _api.authenticated,
            initialDates: dates,
            onConnect: () => setState(() => _index = 3),
            onReservations: () => setState(() => _index = 2))));
    if (mounted) _catalog.refresh();
  }

  Future<void> _manage(BuildContext context, Vehicle vehicle) async {
    await Navigator.of(context).push<void>(MaterialPageRoute(
        builder: (_) => VehicleOperationsScreen(api: _api, vehicle: vehicle)));
    if (mounted) {
      await Future.wait([_inventory.load(workspace: true), _catalog.refresh()]);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Precision Mobility',
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: StudioTheme.light(),
      darkTheme: StudioTheme.dark(),
      themeMode: _theme,
      home: Builder(
          builder: (context) => MobilityShell(
                  index: _index,
                  connected: _api.authenticated,
                  examples: _api.examples,
                  switching: _switching,
                  connectionError: _sessionError,
                  onRetry: _openExamples,
                  onSelected: (i) => setState(() => _index = i),
                  pages: [
                    CatalogScreen(
                        controller: _catalog,
                        onOpen: (v, dates) => _open(context, v, dates),
                        onAddVehicle: () => _api.authenticated
                            ? _edit(context, null)
                            : setState(() => _index = 3)),
                    InventoryScreen(
                        controller: _inventory,
                        connected: _api.authenticated,
                        onConnect: () => setState(() => _index = 3),
                        onManage: (v) => _manage(context, v),
                        onEdit: (v) => _edit(context, v)),
                    ReservationsScreen(
                        controller: _reservations,
                        connected: _api.authenticated,
                        onConnect: () => setState(() => _index = 3),
                        onDiscover: () => setState(() => _index = 0),
                        onChanged: _catalog.refresh),
                    WorkspaceScreen(
                        api: _api,
                        onExamples: _openExamples,
                        inventory: _inventory,
                        reservations: _reservations,
                        onSessionChanged: _sessionChanged,
                        themeMode: _theme,
                        onThemeChanged: (mode) =>
                            setState(() => _theme = mode)),
                  ])));
}
