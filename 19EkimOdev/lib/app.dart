import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/widgets/app_shell.dart';
import 'data/demo/demo_clinic_store.dart';

/// VenaFlow kök uygulama widget'ı.
///
/// Material 3 temasını, aydınlık/karanlık/sistem modu dinamik geçişini
/// ve kurgusal poliklinik veri deposunu (`DemoClinicStore`) yönetir.
class VenaFlowApp extends StatelessWidget {
  const VenaFlowApp({
    super.key,
    required this.store,
    required this.themeController,
  });

  final DemoClinicStore store;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.mode,
      builder: (BuildContext context, ThemeMode mode, _) {
        return MaterialApp(
          title: 'VenaFlow',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: AppShell(
            store: store,
            themeController: themeController,
          ),
        );
      },
    );
  }
}
