import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/app/meheng_app.dart';
import 'package:meheng/features/ventures/presentation/venture_providers.dart';
import 'fakes/fake_venture_repository.dart';

void main() {
  testWidgets('home opens and shows venture empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ventureRepositoryProvider.overrideWithValue(FakeVentureRepository()),
        ],
        child: const MehengApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('MeHEnG'), findsOneWidget);
    expect(find.textContaining('Henüz bir girişim yok'), findsOneWidget);
    expect(find.byIcon(Icons.dashboard), findsWidgets);
  });
}
