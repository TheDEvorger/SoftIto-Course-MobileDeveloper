import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_mobility/app/precision_app.dart';

void main() {
  testWidgets(
      'complete sample reservation and 20-slot physical handover journey',
      (tester) async {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Future<void> tap(Finder target) async {
      await tester.scrollUntilVisible(target, 250,
          scrollable: find.byType(Scrollable).last);
      await tester.pumpAndSettle();
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(const PrecisionApp());
    await tester.enterText(find.byType(TextField), 'urban');
    await tester.pumpAndSettle();
    await tap(find.text('Aracı incele'));
    await tap(find.text('Rezervasyon demosunu aç'));
    await tap(find.text('Örnek teklif oluştur'));
    await tap(find.text('Demo onayı ver'));
    expect(find.text('Demo rezervasyon onaylandı'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sürüşlerim'));
    await tester.pumpAndSettle();
    await tap(find.text('Teslim demosunu aç'));
    for (final label in [
      'Örnek teslim zamanı uygun',
      'Örnek sürücü yetkili',
      'Örnek araç koşulları uygun'
    ]) {
      await tap(find.text(label));
    }
    await tap(find.text('Demo ön kontrolü çalıştır'));
    await tap(find.text('20 açılı inceleme demosunu aç'));
    for (var i = 0; i < 20; i++) {
      await tap(find.byKey(ValueKey('upload-$i')));
      await tap(find.byKey(ValueKey('accept-$i')));
    }
    await tap(find.text('20/20 inceleme demosunu tamamla'));
    for (final label in [
      'Örnek sayaç ve enerji kaydedildi',
      'Örnek teslim tarafları doğrulandı',
      'Örnek karşılıklı kabul verildi'
    ]) {
      await tap(find.text(label));
    }
    await tap(find.text('Teslim demosunu tamamla'));
    expect(find.text('Simülasyon tamamlandı. Gerçek sürüş başlatılmadı.'),
        findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
