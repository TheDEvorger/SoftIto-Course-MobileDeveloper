import 'package:flutter/material.dart';

import 'core/theme/garden_theme.dart';
import 'features/shell/presentation/app_shell.dart';

class GardenYksApp extends StatelessWidget {
  const GardenYksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fantastik Bahçe YKS',
      theme: GardenTheme.light,
      darkTheme: GardenTheme.dark,
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}
