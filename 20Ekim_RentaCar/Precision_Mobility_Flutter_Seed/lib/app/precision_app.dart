import 'package:flutter/material.dart';
import '../core/theme/precision_theme.dart';
import 'shell.dart';
import '../features/inspections/application/demo_inspection_store.dart';
import '../features/inspections/presentation/inspection_demo_screen.dart';
import '../features/handover/presentation/handover_demo_screen.dart';
import '../features/bookings/domain/booking_ledger.dart';
import '../features/bookings/application/demo_booking_scope.dart';
import '../features/bookings/presentation/booking_demo_screen.dart';
import '../features/discovery/domain/demo_vehicle.dart';
import '../shared/widgets/precision_empty_state.dart';

class PrecisionApp extends StatefulWidget {
  const PrecisionApp({super.key});
  @override
  State<PrecisionApp> createState() => _PrecisionAppState();
}

class _PrecisionAppState extends State<PrecisionApp> {
  ThemeMode _mode = ThemeMode.system;
  final _bookings = DemoBookingController();
  final _inspections = DemoInspectionStore();
  @override
  void dispose() {
    _bookings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DemoBookingScope(
      controller: _bookings,
      child: MaterialApp(
        title: 'Precision Mobility',
        onGenerateRoute: (settings) {
          if ((settings.name == '/handover' ||
                  settings.name == '/inspection') &&
              settings.arguments is String) {
            final id = settings.arguments as String;
            bool eligible() {
              try {
                return _bookings.ledger.get(id, _bookings.clock()).state ==
                    BookingState.confirmed;
              } on StateError {
                return false;
              }
            }

            if (settings.name == '/inspection' && eligible()) {
              return MaterialPageRoute<bool>(
                  settings: settings,
                  builder: (_) => InspectionDemoScreen(
                      draft: _inspections.open(id), onSave: _inspections.save));
            }
            if (settings.name == '/handover') {
              return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => HandoverDemoScreen(
                      bookingId: id,
                      isBookingConfirmed: eligible,
                      openInspection: (context) async =>
                          await Navigator.of(context)
                              .pushNamed<bool>('/inspection', arguments: id) ??
                          false));
            }
          }
          final vehicle = settings.arguments is String
              ? findDemoVehicle(settings.arguments as String)
              : null;
          return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => settings.name == '/booking' && vehicle != null
                  ? BookingDemoScreen(
                      vehicleId: vehicle.id,
                      vehicleName: vehicle.name,
                      dailyRate: vehicle.pricePerDay)
                  : const Scaffold(
                      body: PrecisionEmptyState(
                          title: 'Sayfa bulunamadı',
                          message: 'Geri dönüp bir örnek araç seçin.')));
        },
        debugShowCheckedModeBanner: false,
        theme: PrecisionTheme.light(),
        darkTheme: PrecisionTheme.dark(),
        themeMode: _mode,
        home: AppShell(
          themeMode: _mode,
          onThemeChanged: (mode) => setState(() => _mode = mode),
        ),
      ));
}
