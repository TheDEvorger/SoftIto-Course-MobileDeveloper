import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/app/meheng_app.dart';
import 'package:meheng/features/ventures/presentation/venture_providers.dart';
import '../../fakes/fake_venture_repository.dart';

void main() {
  late FakeVentureRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeVentureRepository();
  });

  Widget buildApp() {
    return ProviderScope(
      overrides: [ventureRepositoryProvider.overrideWithValue(fakeRepo)],
      child: const MehengApp(),
    );
  }

  group('Responsive Layout Shell (360 / 600 / 900 / 1440)', () {
    testWidgets('360px mobile viewport uses bottom NavigationBar', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('MeHEnG'), findsOneWidget);
    });

    testWidgets('600px tablet portrait viewport uses bottom NavigationBar', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(600, 960);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('900px desktop viewport uses NavigationRail (collapsed)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(900, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
    });

    testWidgets('1440px wide desktop viewport uses extended NavigationRail', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
    });
  });
}
