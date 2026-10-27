// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_magaza/main.dart';

void main() {
  testWidgets('Ürün listesi yüklenir', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniMagazaUygulamasi());

    // İlk açılışta yükleniyor göstergesi görünmeli.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Mock servisin gecikmesi bitince ürünler gelmeli.
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('9 Adet Ürün Hazır.'), findsOneWidget);
  });
}
