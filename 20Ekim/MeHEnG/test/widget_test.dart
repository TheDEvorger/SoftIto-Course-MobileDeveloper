import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/features/discover/domain/evidence.dart';

void main() {
  test('evidence classification has three explicit states', () {
    expect(EvidenceDirection.values.length, 3);
    expect(
      EvidenceDirection.values.byName('contradicts'),
      EvidenceDirection.contradicts,
    );
  });
}
