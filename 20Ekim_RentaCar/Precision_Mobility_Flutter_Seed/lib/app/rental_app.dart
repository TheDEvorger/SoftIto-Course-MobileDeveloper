import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/studio_theme.dart';
import '../features/rental/application/rental_controller.dart';
import '../features/rental/data/device_rental_repository.dart';
import '../features/rental/data/rental_catalog.dart';
import '../features/rental/data/rental_storage.dart';
import '../features/rental/domain/rental_vehicle.dart';
import '../features/rental/presentation/rental_catalog_screen.dart';
import '../features/rental/presentation/rental_detail_screen.dart';
import '../features/rental/presentation/rental_plans_screen.dart';
import '../features/rental/presentation/rental_profile_screen.dart';
import 'rental_shell.dart';

class RentalApp extends StatefulWidget {
  const RentalApp({super.key, this.repository});
  final DeviceRentalRepository? repository;
  @override
  State<RentalApp> createState() => _RentalAppState();
}

class _RentalAppState extends State<RentalApp> {
  late final RentalController _controller;
  int _index = 0;
  @override
  void initState() {
    super.initState();
    _controller = RentalController(widget.repository ??
        DeviceRentalRepository(DeviceRentalStorage(), rentalCatalog))
      ..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _open(
          BuildContext context, RentalVehicle vehicle, DateTimeRange? dates) =>
      Navigator.of(context).push<void>(MaterialPageRoute(
          builder: (context) => RentalDetailScreen(
              controller: _controller,
              vehicle: vehicle,
              initialDates: dates,
              onReservations: () {
                Navigator.of(context).pop();
                setState(() => _index = 2);
              })));
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => MaterialApp(
            title: 'Precision · Araç Kiralama',
            debugShowCheckedModeBanner: false,
            theme: StudioTheme.light(fontFamily: 'PrecisionRoboto'),
            darkTheme: StudioTheme.dark(fontFamily: 'PrecisionRoboto'),
            themeMode: switch (_controller.repository.data.theme) {
              'dark' => ThemeMode.dark,
              'light' => ThemeMode.light,
              _ => ThemeMode.system
            },
            locale: const Locale('tr', 'TR'),
            supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            home: Builder(
                builder: (context) => RentalShell(
                        index: _index,
                        onSelected: (index) => setState(() => _index = index),
                        loading: _controller.loading,
                        error: _controller.error,
                        onRetry: _controller.load,
                        pages: [
                          RentalCatalogScreen(
                              controller: _controller,
                              onOpen: (v, dates) => _open(context, v, dates)),
                          RentalCatalogScreen(
                              controller: _controller,
                              favoritesOnly: true,
                              onOpen: (v, dates) => _open(context, v, dates)),
                          RentalPlansScreen(
                              controller: _controller,
                              onDiscover: () => setState(() => _index = 0),
                              onOpen: (v) => _open(context, v, null)),
                          RentalProfileScreen(
                              controller: _controller,
                              onPlans: () => setState(() => _index = 2),
                              onFavorites: () => setState(() => _index = 1)),
                        ])),
          ));
}
