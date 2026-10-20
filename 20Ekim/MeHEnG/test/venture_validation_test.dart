import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/features/ventures/domain/venture.dart';

void main() {
  test('venture name minimum length and max length', () {
    expect(Venture.validateName('a'), isNotNull);
    expect(Venture.validateName('  '), isNotNull);
    expect(Venture.validateName('abc'), isNull);
    expect(Venture.validateName('a' * 81), isNotNull);
  });
}
