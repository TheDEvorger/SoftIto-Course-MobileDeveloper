import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routing/app_router.dart';
import 'theme/meheng_theme.dart';
import 'theme/theme_provider.dart';

class MehengApp extends ConsumerWidget {
  const MehengApp({super.key, this.initialThemeMode});

  final ThemeMode? initialThemeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = initialThemeMode ?? ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'MeHEnG',
      debugShowCheckedModeBanner: false,
      theme: MehengTheme.light,
      darkTheme: MehengTheme.dark,
      themeMode: mode,
      routerConfig: appRouter,
    );
  }
}
