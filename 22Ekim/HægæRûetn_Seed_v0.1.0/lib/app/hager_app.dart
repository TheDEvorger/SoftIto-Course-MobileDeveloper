import 'package:flutter/material.dart';
import '../core/state/realm_controller.dart';
import '../features/shell/realm_shell.dart';

class HagerApp extends StatelessWidget {
  const HagerApp({super.key, required this.controller});
  final RealmController controller;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'HægæRûetn',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F6EF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF247C80),
        surface: const Color(0xFFF8F6EF),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: -1.3),
        headlineMedium: TextStyle(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -0.7),
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(fontSize: 14, height: 1.42),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    home: RealmShell(controller: controller),
  );
}
