import 'package:flutter/material.dart';
import '../../../core/theme/garden_palette.dart';

enum PomodoroMode {
  focus,
  shortBreak,
  longBreak,
}

extension PomodoroModeX on PomodoroMode {
  String get label {
    switch (this) {
      case PomodoroMode.focus:
        return 'Odaklanma';
      case PomodoroMode.shortBreak:
        return 'Kısa Mola';
      case PomodoroMode.longBreak:
        return 'Uzun Mola';
    }
  }

  int get defaultSeconds {
    switch (this) {
      case PomodoroMode.focus:
        return 25 * 60;
      case PomodoroMode.shortBreak:
        return 5 * 60;
      case PomodoroMode.longBreak:
        return 15 * 60;
    }
  }

  IconData get icon {
    switch (this) {
      case PomodoroMode.focus:
        return Icons.self_improvement;
      case PomodoroMode.shortBreak:
        return Icons.coffee_outlined;
      case PomodoroMode.longBreak:
        return Icons.nature_people_outlined;
    }
  }

  Color get accentColor {
    switch (this) {
      case PomodoroMode.focus:
        return GardenPalette.mossEmerald;
      case PomodoroMode.shortBreak:
        return GardenPalette.streamTurquoise;
      case PomodoroMode.longBreak:
        return GardenPalette.peachCoral;
    }
  }
}
