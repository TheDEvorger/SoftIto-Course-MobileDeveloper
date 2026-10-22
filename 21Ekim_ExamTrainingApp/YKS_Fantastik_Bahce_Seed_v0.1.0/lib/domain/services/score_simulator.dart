import '../models/score_simulation.dart';

/// ÖSYM YKS kılavuz standartlarına dayalı güvenli puan simülasyon motoru.
class ScoreSimulator {
  const ScoreSimulator();

  static const int curriculumYear = 2026;

  static const String disclaimerText =
      'ÖSYM puanları ilgili sınav yılının Türkiye genel ortalaması ve standart sapmasına göre hesaplanır. '
      'Bu hesaplama, geçmiş yılların ortalama katsayılarına dayalı yaklaşık/temsili bir tahmindir ve '
      'resmî sınav sonucu veya sıralama garantisi yerine geçmez.';

  /// TYT Ham Puanı Hesapla (Taban 100, Tavan 500)
  double calculateTytRawScore({
    required double turkce,
    required double matematik,
    required double sosyal,
    required double fen,
  }) {
    final clampedTurkce = turkce.clamp(0.0, 40.0);
    final clampedMat = matematik.clamp(0.0, 40.0);
    final clampedSosyal = sosyal.clamp(0.0, 20.0);
    final clampedFen = fen.clamp(0.0, 20.0);

    // Katsayılar: 120 net tam yapıldığında tam 500.0 verecek şekilde dengelenmiştir.
    // 100 (taban) + 40*3.30 + 40*3.30 + 20*3.40 + 20*3.40 = 500.0
    final score = 100.0 +
        (clampedTurkce * 3.30) +
        (clampedMat * 3.30) +
        (clampedSosyal * 3.40) +
        (clampedFen * 3.40);

    return score.clamp(100.0, 500.0);
  }

  /// OBP ve Yerleştirme Katkısı Hesapla
  double calculateObpScore(double diplomaGrade) {
    final grade = diplomaGrade.clamp(50.0, 100.0);
    return grade * 5.0; // 250.0 - 500.0
  }

  double calculateObpContribution(double obpScore, bool isPreviousYearPlaced) {
    final multiplier = isPreviousYearPlaced ? 0.06 : 0.12;
    return obpScore * multiplier;
  }

  /// Alan Puanı ve Yerleştirme Simülasyonu
  SimulationResult simulate(SimulationInput input) {
    final tytRaw = calculateTytRawScore(
      turkce: input.tytTurkce,
      matematik: input.tytMatematik,
      sosyal: input.tytSosyal,
      fen: input.tytFen,
    );

    double fieldRaw;

    if (input.field == SimulationField.tytOnly) {
      fieldRaw = tytRaw;
    } else {
      // AYT puanında TYT %40 ağırlığa sahiptir (160 puan payı).
      final tytContribution = (tytRaw - 100.0) * 0.40;
      double aytNetPoints = 0.0;

      switch (input.field) {
        case SimulationField.sayisal:
          final mat = input.aytMatematik.clamp(0.0, 40.0) * 3.00;
          final fiz = input.aytFizik.clamp(0.0, 14.0) * 2.85;
          final kim = input.aytKimya.clamp(0.0, 13.0) * 3.07;
          final bio = input.aytBiyoloji.clamp(0.0, 13.0) * 3.07;
          aytNetPoints = mat + fiz + kim + bio;
          break;

        case SimulationField.esitAgirlik:
          final mat = input.aytMatematik.clamp(0.0, 40.0) * 3.00;
          final edb = input.aytEdebiyat.clamp(0.0, 24.0) * 3.00;
          final tar1 = input.aytTarih1.clamp(0.0, 10.0) * 2.80;
          final cog1 = input.aytCografya1.clamp(0.0, 6.0) * 3.33;
          aytNetPoints = mat + edb + tar1 + cog1;
          break;

        case SimulationField.sozel:
          final edb = input.aytEdebiyat.clamp(0.0, 24.0) * 3.00;
          final tar1 = input.aytTarih1.clamp(0.0, 10.0) * 2.80;
          final cog1 = input.aytCografya1.clamp(0.0, 6.0) * 3.33;
          // Sözel-2 temsili puanı
          final sos2 =
              (input.aytTarih1 + input.aytCografya1).clamp(0.0, 40.0) * 2.40;
          aytNetPoints = edb + tar1 + cog1 + sos2;
          break;

        case SimulationField.tytOnly:
          break;
      }

      fieldRaw = (100.0 + tytContribution + aytNetPoints).clamp(100.0, 500.0);
    }

    final obp = calculateObpScore(input.diplomaGrade);
    final obpContribution =
        calculateObpContribution(obp, input.isPreviousYearPlaced);
    final placement = fieldRaw + obpContribution;

    return SimulationResult(
      field: input.field,
      tytScore: tytRaw,
      fieldRawScore: fieldRaw,
      obpScore: obp,
      obpContribution: obpContribution,
      placementScore: placement,
      disclaimer: disclaimerText,
      curriculumYear: curriculumYear,
    );
  }
}
