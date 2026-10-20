import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/features/ventures/presentation/venture_providers.dart';
import '../../fakes/fake_venture_repository.dart';

void main() {
  late FakeVentureRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeVentureRepository();
    container = ProviderContainer(
      overrides: [ventureRepositoryProvider.overrideWithValue(fakeRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Venture Providers & ViewModel', () {
    test('initial state has empty ventures list', () {
      final list = container.read(venturesProvider);
      expect(list, isEmpty);
    });

    test('ventureProvider returns null for non-existing id', () {
      final venture = container.read(ventureProvider('non-existent'));
      expect(venture, isNull);
    });

    test(
      'create adds venture, trims inputs, and invalidates venturesProvider',
      () {
        final vm = container.read(ventureViewModelProvider);

        vm.create(
          name: '  Yenilikçi SaaS  ',
          problem: '  Pazar analizi zor  ',
          audience: '  Erken aşama girişimciler  ',
        );

        final list = container.read(venturesProvider);
        expect(list.length, 1);
        final created = list.first;
        expect(created.name, 'Yenilikçi SaaS');
        expect(created.problem, 'Pazar analizi zor');
        expect(created.audience, 'Erken aşama girişimciler');

        final found = container.read(ventureProvider(created.id));
        expect(found, isNotNull);
        expect(found?.name, 'Yenilikçi SaaS');
      },
    );

    test('create throws ArgumentError when name is less than 3 chars', () {
      final vm = container.read(ventureViewModelProvider);

      expect(
        () => vm.create(name: 'ab', problem: 'Prob', audience: 'Aud'),
        throwsArgumentError,
      );
    });

    test('create throws ArgumentError when name is whitespace only', () {
      final vm = container.read(ventureViewModelProvider);

      expect(
        () => vm.create(name: '   ', problem: 'Prob', audience: 'Aud'),
        throwsArgumentError,
      );
    });

    test('create throws ArgumentError when name exceeds 80 chars', () {
      final vm = container.read(ventureViewModelProvider);
      final longName = 'A' * 81;

      expect(
        () => vm.create(name: longName, problem: 'Prob', audience: 'Aud'),
        throwsArgumentError,
      );
    });
  });
}
