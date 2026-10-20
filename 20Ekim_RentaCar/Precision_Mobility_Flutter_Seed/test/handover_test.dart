import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/features/handover/domain/demo_handover.dart';
import 'package:precision_mobility/features/handover/presentation/handover_demo_screen.dart';

void main() {
  HandoverPrerequisites ready(
          {bool booking = true,
          bool window = true,
          bool driver = true,
          bool vehicle = true,
          bool compatible = true}) =>
      HandoverPrerequisites(
          bookingConfirmed: booking,
          pickupWindow: window,
          driverAuthorized: driver,
          vehicleReady: vehicle,
          compatible: compatible);
  void finish(DemoHandover h,
          {bool booking = true,
          bool inspection = true,
          bool readings = true,
          bool parties = true,
          bool acceptance = true}) =>
      h.finish(
          bookingStillConfirmed: booking,
          inspectionComplete: inspection,
          readingsRecorded: readings,
          partiesVerified: parties,
          mutualAcceptance: acceptance);

  for (final mode in HandoverMode.values) {
    test('$mode blocks every missing prerequisite and inspection', () {
      final h = DemoHandover(mode);
      expect(() => finish(h), throwsStateError);
      for (final invalid in [
        ready(booking: false),
        ready(window: false),
        ready(driver: false),
        ready(vehicle: false)
      ]) {
        expect(() => h.preflight(invalid), throwsStateError);
        expect(h.preflightPassed, isFalse);
      }
      h.preflight(ready());
      if (mode == HandoverMode.digital) h.acknowledgeDemoUnlock(accepted: true);
      expect(() => finish(h, booking: false), throwsStateError);
      expect(() => finish(h, inspection: false), throwsStateError);
      expect(() => finish(h, readings: false), throwsStateError);
      expect(() => finish(h, acceptance: false), throwsStateError);
      if (mode == HandoverMode.physical) {
        expect(() => finish(h, parties: false), throwsStateError);
      }
      finish(h);
      expect(h.completed, isTrue);
      expect(() => finish(h), throwsStateError);
      h.invalidate();
      expect(h.completed, isFalse);
    });
  }
  test('digital compatibility, negative response and uncertainty fail closed',
      () {
    final h = DemoHandover(HandoverMode.digital);
    expect(() => h.acknowledgeDemoUnlock(accepted: true), throwsStateError);
    expect(() => h.preflight(ready(compatible: false)), throwsStateError);
    h.preflight(ready());
    expect(() => finish(h), throwsStateError);
    h.acknowledgeDemoUnlock(accepted: false);
    expect(() => finish(h), throwsStateError);
    h.acknowledgeDemoUnlock(accepted: true);
    h.connectionLost();
    expect(h.lock, DemoLockState.uncertain);
    expect(() => finish(h), throwsStateError);
    h.preflight(ready());
    h.acknowledgeDemoUnlock(accepted: true);
    finish(h);
    expect(h.completed, isTrue);
  });
  testWidgets('demo screen exposes errors without claiming trip start',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: HandoverDemoScreen(
            bookingId: 'demo', isBookingConfirmed: () => false)));
    await tester.scrollUntilVisible(find.text('Teslim demosunu tamamla'), 300);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teslim demosunu tamamla'));
    await tester.pumpAndSettle();
    expect(
        find.text(
            'Ön kontrol, inceleme, sayaç/enerji ve karşılıklı onay eksik.'),
        findsOneWidget);
    expect(find.text('Simülasyon tamamlandı. Gerçek sürüş başlatılmadı.'),
        findsNothing);
    expect(tester.takeException(), isNull);
  });
}
