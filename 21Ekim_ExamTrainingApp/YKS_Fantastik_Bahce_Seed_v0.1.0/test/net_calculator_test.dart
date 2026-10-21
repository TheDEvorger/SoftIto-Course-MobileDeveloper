import 'package:flutter_test/flutter_test.dart';
import 'package:fantastik_bahce_yks/domain/exam/net_calculator.dart';

void main() {
  group('NetCalculator', () {
    test('30 doğru 8 yanlış = 28 net', () {
      expect(NetCalculator.calculate(correct: 30, wrong: 8), 28);
    });
    test('sıfır doğru sıfır yanlış = sıfır net', () {
      expect(NetCalculator.calculate(correct: 0, wrong: 0), 0);
    });
    test('negatif değer reddedilir', () {
      expect(() => NetCalculator.calculate(correct: -1, wrong: 2),
          throwsRangeError);
    });
    test('40 soruda 32 doğru ve 10 yanlış geçersiz', () {
      expect(NetCalculator.fitsExam(correct: 32, wrong: 10, questionCount: 40),
          isFalse);
    });
    test('40 soruda 30 doğru ve 8 yanlış geçerli', () {
      expect(NetCalculator.fitsExam(correct: 30, wrong: 8, questionCount: 40),
          isTrue);
    });
  });
}
