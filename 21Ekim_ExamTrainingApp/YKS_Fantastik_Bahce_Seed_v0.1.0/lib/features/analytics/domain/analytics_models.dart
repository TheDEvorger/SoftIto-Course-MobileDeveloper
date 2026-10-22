import '../../../domain/models/exam_record.dart';

class AnalyticsDataPoint {
  const AnalyticsDataPoint({
    required this.id,
    required this.title,
    required this.date,
    required this.net,
    this.subjectName,
  });

  final String id;
  final String title;
  final DateTime date;
  final double net;
  final String? subjectName;
}

class TrendSummary {
  const TrendSummary({
    required this.totalExams,
    required this.latestNet,
    required this.previousNet,
    required this.netChange,
    required this.averageNet,
    required this.highestNet,
    required this.lowestNet,
    required this.hasSufficientData,
  });

  final int totalExams;
  final double? latestNet;
  final double? previousNet;
  final double? netChange;
  final double averageNet;
  final double highestNet;
  final double lowestNet;
  final bool hasSufficientData;

  String get changeText {
    if (netChange == null || !hasSufficientData) {
      return 'Karşılaştırma için en az 2 deneme gerekiyor';
    }
    if (netChange! > 0) {
      return '+${netChange!.toStringAsFixed(2)} net artış';
    } else if (netChange! < 0) {
      return '${netChange!.toStringAsFixed(2)} net azalış';
    } else {
      return 'Son denemeyle aynı net';
    }
  }
}

class SubjectNetStat {
  const SubjectNetStat({
    required this.subjectId,
    required this.subjectName,
    required this.averageNet,
    required this.latestNet,
    required this.examCount,
  });

  final String subjectId;
  final String subjectName;
  final double averageNet;
  final double latestNet;
  final int examCount;
}

abstract final class AnalyticsCalculator {
  /// Denemeleri kronolojik sıraya (eskiden yeniye) dizer ve seçilen derse göre veri noktaları üretir.
  static List<AnalyticsDataPoint> extractPoints({
    required List<ExamSession> exams,
    String? subjectId, // null = Toplam Net
  }) {
    if (exams.isEmpty) return const [];

    // Kronolojik sıra (eskiden yeniye)
    final sorted = List<ExamSession>.from(exams)
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    final points = <AnalyticsDataPoint>[];

    for (final exam in sorted) {
      if (subjectId == null) {
        // Genel toplam net
        points.add(
          AnalyticsDataPoint(
            id: exam.id,
            title: exam.title,
            date: exam.occurredAt,
            net: exam.totalNet,
          ),
        );
      } else {
        // Belirli bir dersin neti
        final matchingScores =
            exam.scores.where((s) => s.subjectId == subjectId);
        if (matchingScores.isNotEmpty) {
          final score = matchingScores.first;
          points.add(
            AnalyticsDataPoint(
              id: exam.id,
              title: exam.title,
              date: exam.occurredAt,
              net: score.net,
              subjectName: score.subjectName,
            ),
          );
        }
      }
    }

    return points;
  }

  /// Veri noktalarından trend özetini hesaplar.
  static TrendSummary calculateTrend(List<AnalyticsDataPoint> points) {
    if (points.isEmpty) {
      return const TrendSummary(
        totalExams: 0,
        latestNet: null,
        previousNet: null,
        netChange: null,
        averageNet: 0.0,
        highestNet: 0.0,
        lowestNet: 0.0,
        hasSufficientData: false,
      );
    }

    final totalExams = points.length;
    final latestNet = points.last.net;
    final previousNet =
        points.length >= 2 ? points[points.length - 2].net : null;
    final netChange = previousNet != null ? latestNet - previousNet : null;

    double sum = 0.0;
    double highest = points.first.net;
    double lowest = points.first.net;

    for (final p in points) {
      sum += p.net;
      if (p.net > highest) highest = p.net;
      if (p.net < lowest) lowest = p.net;
    }

    return TrendSummary(
      totalExams: totalExams,
      latestNet: latestNet,
      previousNet: previousNet,
      netChange: netChange,
      averageNet: sum / totalExams,
      highestNet: highest,
      lowestNet: lowest,
      hasSufficientData: points.length >= 2,
    );
  }

  /// Tüm derslerin ortalama ve son net istatistiklerini hesaplar.
  static List<SubjectNetStat> extractSubjectStats(List<ExamSession> exams) {
    if (exams.isEmpty) return const [];

    final sorted = List<ExamSession>.from(exams)
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    final Map<String, List<double>> subjectNetMap = {};
    final Map<String, String> subjectNameMap = {};
    final Map<String, double> latestScoreMap = {};

    for (final exam in sorted) {
      for (final score in exam.scores) {
        subjectNetMap.putIfAbsent(score.subjectId, () => []).add(score.net);
        subjectNameMap[score.subjectId] = score.subjectName;
        latestScoreMap[score.subjectId] = score.net;
      }
    }

    final stats = <SubjectNetStat>[];
    for (final entry in subjectNetMap.entries) {
      final subId = entry.key;
      final nets = entry.value;
      final avg = nets.reduce((a, b) => a + b) / nets.length;
      stats.add(
        SubjectNetStat(
          subjectId: subId,
          subjectName: subjectNameMap[subId] ?? subId,
          averageNet: avg,
          latestNet: latestScoreMap[subId] ?? 0.0,
          examCount: nets.length,
        ),
      );
    }

    // İsme göre sırala
    stats.sort((a, b) => a.subjectName.compareTo(b.subjectName));
    return stats;
  }
}
