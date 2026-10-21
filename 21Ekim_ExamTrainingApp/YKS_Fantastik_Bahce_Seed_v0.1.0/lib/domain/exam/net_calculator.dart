/// Doğru ve yanlış sayılarından standart net sonucunu üretir.
/// Soru üst sınırı ekranın oturum/branş planında ayrıca doğrulanmalıdır.
abstract final class NetCalculator {
  static double calculate({required int correct, required int wrong}) {
    if (correct < 0 || wrong < 0) {
      throw RangeError('Doğru ve yanlış sayıları negatif olamaz.');
    }
    return correct - (wrong / 4.0);
  }

  static bool fitsExam({
    required int correct,
    required int wrong,
    required int questionCount,
  }) {
    return correct >= 0 &&
        wrong >= 0 &&
        questionCount >= 0 &&
        correct + wrong <= questionCount;
  }
}
