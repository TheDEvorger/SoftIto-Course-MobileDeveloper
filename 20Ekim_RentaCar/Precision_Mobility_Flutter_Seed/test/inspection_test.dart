import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/features/inspections/domain/evidence_draft.dart';
import 'package:precision_mobility/features/inspections/domain/evidence_template.dart';
import 'package:precision_mobility/features/inspections/application/demo_inspection_store.dart';
import 'package:precision_mobility/features/inspections/presentation/inspection_demo_screen.dart';

void main() {
  final time = DateTime.utc(2030);
  test('all 20 slots require receipt and human demo acceptance', () {
    expect(evidenceAngles.length, 20);
    expect(evidenceAngles.toSet().length, 20);
    final draft = EvidenceDraft('b1');
    for (var i = 0; i < 20; i++) {
      expect(draft.isComplete, isFalse);
      expect(() => draft.review(i, accepted: true), throwsStateError);
      draft.startUpload(i);
      expect(() => draft.startUpload(i), throwsStateError);
      draft.receive(i, time);
      expect(draft.isComplete, isFalse);
      draft.review(i, accepted: true);
    }
    expect(draft.isComplete, isTrue);
    draft.review(3, accepted: false);
    expect(draft.isComplete, isFalse);
    expect(() => draft.review(3, accepted: true), throwsStateError);
    draft.startUpload(3);
    draft.receive(3, time);
    draft.review(3, accepted: true);
    expect(draft.isComplete, isTrue);
    expect(() => draft.startUpload(20), throwsRangeError);
    expect(() => draft.receive(-1, time), throwsRangeError);
  });
  test('failed uploads retry and interrupted snapshots resume safely', () {
    final draft = EvidenceDraft('b1');
    draft.startUpload(0);
    draft.fail(0);
    expect(draft.slots[0].status, EvidenceStatus.failed);
    draft.startUpload(0);
    draft.receive(0, time);
    draft.review(0, accepted: true);
    draft.startUpload(1);
    final json = Map<String, Object?>.from(
        jsonDecode(jsonEncode(draft.toJson())) as Map);
    final restored = EvidenceDraft.restore(json, expectedBookingId: 'b1');
    expect(restored.acceptedCount, 1);
    expect(restored.slots[0].receivedAt, time);
    expect(restored.slots[1].status, EvidenceStatus.failed);
    restored.startUpload(1);
    restored.receive(1, time);
    expect(restored.slots[1].review, EvidenceReview.pending);
    final store = DemoInspectionStore();
    store.save(restored);
    expect(store.open('b1').acceptedCount, 1);
    expect(store.open('b2').acceptedCount, 0);
    expect(() => EvidenceDraft.restore(json, expectedBookingId: 'b2'),
        throwsFormatException);
    expect(
        () => EvidenceDraft.restore({...json, 'version': 'future'},
            expectedBookingId: 'b1'),
        throwsFormatException);
    expect(
        () => EvidenceDraft.restore({...json, 'slots': []},
            expectedBookingId: 'b1'),
        throwsFormatException);
  });
  testWidgets('synthetic upload and review survive reopening', (tester) async {
    final store = DemoInspectionStore();
    Future<void> open() async {
      await tester.pumpWidget(MaterialApp(
          home: InspectionDemoScreen(
              key: UniqueKey(), draft: store.open('b1'), onSave: store.save)));
      await tester.pumpAndSettle();
    }

    await open();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('upload-0')), 200);
    await tester.tap(find.byKey(const ValueKey('upload-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('accept-0')));
    await tester.pumpAndSettle();
    expect(store.open('b1').acceptedCount, 1);
    await tester.drag(find.byType(ListView), const Offset(0, 700));
    await tester.pumpAndSettle();
    expect(find.text('1/20 örnek kabul edildi'), findsOneWidget);
    await open();
    expect(find.text('1/20 örnek kabul edildi'), findsOneWidget);
    expect(store.open('b1').isComplete, isFalse);
    expect(tester.takeException(), isNull);
  });
}
