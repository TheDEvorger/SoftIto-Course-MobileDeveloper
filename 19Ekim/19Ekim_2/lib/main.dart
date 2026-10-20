import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';

void main() {
  runApp(const SusadimApp());
}

class SusadimApp extends StatefulWidget {
  const SusadimApp({
    super.key,
    this.themeController,
  });

  final ThemeController? themeController;

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final ThemeController _themeController;
  late final bool _isInternalController;

  @override
  void initState() {
    super.initState();
    if (widget.themeController != null) {
      _themeController = widget.themeController!;
      _isInternalController = false;
    } else {
      _themeController = ThemeController();
      _isInternalController = true;
    }
  }

  @override
  void dispose() {
    if (_isInternalController) {
      _themeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          home: WaterTrackerView(themeController: _themeController),
        );
      },
    );
  }
}
