import 'package:flutter/material.dart';

abstract final class AppColors {
  // Karanlık tema — gece spor salonu (dark obsidian & neon)
  static const Color obsidian = Color(0xFF0B0D12);
  static const Color obsidianSurface = Color(0xFF151922);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonLime = Color(0xFFB6FF3B);
  static const Color darkOnSurface = Color(0xFFE6EAF2);

  // Aydınlık tema — gündüz salonu (frost white & deep water)
  static const Color frost = Color(0xFFF5F8FC);
  static const Color frostSurface = Color(0xFFFFFFFF);
  static const Color deepWater = Color(0xFF006C80);
  static const Color freshLime = Color(0xFF4C7A00);
  static const Color lightOnSurface = Color(0xFF12161F);

  // Ortak
  static const Color error = Color(0xFFFF4D6D);
}
