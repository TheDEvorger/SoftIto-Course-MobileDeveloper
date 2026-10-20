import 'package:flutter/material.dart';

import 'app.dart';
import 'core/theme/theme_controller.dart';
import 'data/demo/demo_clinic_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final DemoClinicStore store = DemoClinicStore();
  final ThemeController themeController = ThemeController();

  runApp(
    VenaFlowApp(
      store: store,
      themeController: themeController,
    ),
  );
}
