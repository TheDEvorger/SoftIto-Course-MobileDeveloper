import '../../state/realm_controller.dart';

/// Builds a compact, privacy-conscious summary of the user's habits and pacts.
/// Strictly respects user consent — returns null when data sharing is disabled.
class AiContextBuilder {
  const AiContextBuilder();

  /// Produces a compact context string if [consentGranted] is true.
  String? buildContext({
    required RealmController controller,
    required bool consentGranted,
  }) {
    if (!consentGranted) return null;

    final buffer = StringBuffer();
    final c = controller;

    buffer.writeln('- Rütbe: ${c.era.name} Çağı • ${c.rank} (Sv.${c.level})');
    buffer.writeln('- İtibar: ${c.reputation}/100, Tecrübe: ${c.xp} XP');
    buffer.writeln(
        '- Bugünkü durum: ${c.todayCompleted}/${c.activeHabits.length} vazife tamamlandı');

    if (c.activeHabits.isNotEmpty) {
      final habitList = c.activeHabits.take(5).map((h) {
        final done = h.completedOn(c.today);
        return '${h.name} (${done ? "Bugün yapıldı" : "Bekliyor"}, ${h.completedDates.length} kez)';
      }).join(', ');
      buffer.writeln('- Aktif vazifeler: $habitList');
    }

    if (c.pacts.isNotEmpty) {
      final activePacts = c.pacts.where((p) => !p.isCompleted).take(3).map((p) {
        final progress = c.pactProgress(p);
        return '${p.title} ($progress/${p.goalDays} gün)';
      }).join(', ');
      if (activePacts.isNotEmpty) {
        buffer.writeln('- Aktif ahitler: $activePacts');
      }
    }

    return buffer.toString().trim();
  }
}
