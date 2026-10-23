import 'package:flutter/material.dart';
import '../core/state/realm_controller.dart';
import '../core/theme/realm_theme.dart';
import '../features/shell/realm_shell.dart';

class HagerApp extends StatelessWidget {
  const HagerApp({super.key, required this.controller});
  final RealmController controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'HægæRûetn',
        debugShowCheckedModeBanner: false,
        theme: buildRealmTheme(),
        home: RealmShell(controller: controller),
      );
}
