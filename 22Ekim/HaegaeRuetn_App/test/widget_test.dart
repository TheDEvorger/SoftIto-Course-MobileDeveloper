import 'package:flutter_test/flutter_test.dart';
import 'package:haegaruuetn/core/models/era.dart';

void main() {
  test('24th rank is not named Ulu Kral', () {
    expect(rankForLevel(24), 'Taç Giyen');
  });
}
