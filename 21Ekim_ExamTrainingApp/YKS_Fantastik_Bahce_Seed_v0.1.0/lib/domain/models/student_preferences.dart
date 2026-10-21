enum ThemeModePreference { system, light, dark }

class StudentPreferences {
  const StudentPreferences({
    this.id = 'current',
    this.displayName,
    this.field = 'Sayısal',
    this.targetDate,
    this.targetNet,
    this.themeMode = ThemeModePreference.system,
    this.humorousExitEnabled = false,
  });

  final String id;
  final String? displayName;
  final String field;
  final DateTime? targetDate;
  final double? targetNet;
  final ThemeModePreference themeMode;
  final bool humorousExitEnabled;

  StudentPreferences copyWith({
    String? id,
    String? displayName,
    String? field,
    DateTime? targetDate,
    double? targetNet,
    ThemeModePreference? themeMode,
    bool? humorousExitEnabled,
  }) {
    return StudentPreferences(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      field: field ?? this.field,
      targetDate: targetDate ?? this.targetDate,
      targetNet: targetNet ?? this.targetNet,
      themeMode: themeMode ?? this.themeMode,
      humorousExitEnabled: humorousExitEnabled ?? this.humorousExitEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'field': field,
      'target_date': targetDate?.toIso8601String(),
      'target_net': targetNet,
      'theme_mode': themeMode.name,
      'humorous_exit_enabled': humorousExitEnabled ? 1 : 0,
    };
  }

  factory StudentPreferences.fromMap(Map<String, dynamic> map) {
    return StudentPreferences(
      id: map['id'] as String? ?? 'current',
      displayName: map['display_name'] as String?,
      field: map['field'] as String? ?? 'Sayısal',
      targetDate: map['target_date'] != null
          ? DateTime.tryParse(map['target_date'] as String)
          : null,
      targetNet: (map['target_net'] as num?)?.toDouble(),
      themeMode: ThemeModePreference.values.firstWhere(
        (e) => e.name == map['theme_mode'],
        orElse: () => ThemeModePreference.system,
      ),
      humorousExitEnabled: (map['humorous_exit_enabled'] as int?) == 1,
    );
  }
}
