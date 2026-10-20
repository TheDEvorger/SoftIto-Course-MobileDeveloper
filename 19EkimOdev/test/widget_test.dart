import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:venaflow/app.dart';
import 'package:venaflow/core/theme/theme_controller.dart';
import 'package:venaflow/data/demo/demo_clinic_store.dart';

void main() {
  testWidgets('VenaFlow smoke test: Dashboard, sekmeler ve etkileşim',
      (WidgetTester tester) async {
    // Ekran boyutunu tipik bir mobil cihaz için ayarla
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() => tester.view.resetPhysicalSize());

    final DemoClinicStore store = DemoClinicStore();
    final ThemeController themeController = ThemeController();

    await tester.pumpWidget(
      VenaFlowApp(
        store: store,
        themeController: themeController,
      ),
    );
    await tester.pumpAndSettle();

    // 1. Dashboard başlığı ve kartlar görünür olmalı
    expect(find.text('VenaFlow'), findsWidgets);
    expect(find.text('Sırada Bekleyen'), findsOneWidget);
    expect(find.text('İşlemde'), findsOneWidget);
    expect(find.text('Numunesi Alınan'), findsOneWidget);
    expect(find.text('Teslim Edilen'), findsOneWidget);

    // 2. Sıra sekmesine geçiş
    await tester.tap(find.text('Sıra'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('queue_search')), findsOneWidget);

    // 3. Ayarlar sekmesine geçiş ve tema seçimi
    await tester.tap(find.text('Ayarlar'));
    await tester.pumpAndSettle();
    expect(find.text('Ayarlar ve Sistem'), findsOneWidget);
    expect(find.text('Tüm Demo Verilerini Sıfırla'), findsOneWidget);

    // 4. Dashboard'a geri dön
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Sırada Bekleyen'), findsOneWidget);
  });
}
