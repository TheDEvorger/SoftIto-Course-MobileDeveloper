import 'package:flutter/material.dart';

import 'core/theme/garden_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/shell/presentation/app_shell.dart';

class GardenYksApp extends StatelessWidget {
  const GardenYksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.instance.themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fantastik Bahçe YKS',
          theme: GardenTheme.light,
          darkTheme: GardenTheme.dark,
          themeMode: currentThemeMode,
          home: const AppShell(),
        );
      },
    );
  }
}
