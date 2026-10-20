import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/core/database/app_database.dart';
import 'package:meheng/features/discover/data/sqlite_discover_repository.dart';
import 'package:meheng/features/discover/domain/hypothesis.dart';
import 'package:meheng/features/ventures/data/sqlite_venture_repository.dart';
import 'package:meheng/features/ventures/domain/venture.dart';
import 'package:meheng/features/ventures/presentation/venture_providers.dart';
import '../../fakes/fake_venture_repository.dart';

void main() {
  group('Venture Edit and Archive - ViewModel & Providers', () {
    late FakeVentureRepository fakeRepo;
    late ProviderContainer container;
    final now = DateTime.now();

    setUp(() {
      fakeRepo = FakeVentureRepository();
      container = ProviderContainer(
        overrides: [ventureRepositoryProvider.overrideWithValue(fakeRepo)],
      );
    });

    tearDown(() => container.dispose());

    test(
      'update persists changes, trims inputs, and invalidates providers',
      () {
        final initial = Venture(
          id: 'v1',
          name: 'Eski İsim',
          problem: 'Eski Problem',
          audience: 'Eski Kitle',
          createdAt: now,
        );
        fakeRepo.add(initial);

        final vm = container.read(ventureViewModelProvider);
        vm.update(
          id: 'v1',
          name: '  Yeni İsim  ',
          problem: '  Yeni Problem  ',
          audience: '  Yeni Kitle  ',
        );

        final updated = container.read(ventureProvider('v1'));
        expect(updated?.name, 'Yeni İsim');
        expect(updated?.problem, 'Yeni Problem');
        expect(updated?.audience, 'Yeni Kitle');
        expect(updated?.isArchived, isFalse);
      },
    );

    test('update throws ArgumentError on invalid names', () {
      final initial = Venture(
        id: 'v1',
        name: 'Başlangıç',
        problem: 'P',
        audience: 'A',
        createdAt: now,
      );
      fakeRepo.add(initial);

      final vm = container.read(ventureViewModelProvider);
      expect(
        () => vm.update(id: 'v1', name: 'ab', problem: 'P', audience: 'A'),
        throwsArgumentError,
      );
      expect(
        () => vm.update(id: 'v1', name: '   ', problem: 'P', audience: 'A'),
        throwsArgumentError,
      );
      expect(
        () => vm.update(id: 'v1', name: 'A' * 81, problem: 'P', audience: 'A'),
        throwsArgumentError,
      );
    });

    test('update throws StateError when venture is missing', () {
      final vm = container.read(ventureViewModelProvider);
      expect(
        () =>
            vm.update(id: '404', name: 'Geçerli', problem: 'P', audience: 'A'),
        throwsStateError,
      );
    });

    test('archive hides venture by default and restore brings it back', () {
      final v1 = Venture(
        id: 'v1',
        name: 'Girişim 1',
        problem: 'P1',
        audience: 'A1',
        createdAt: now,
      );
      fakeRepo.add(v1);

      expect(container.read(venturesProvider).length, 1);

      final vm = container.read(ventureViewModelProvider);
      vm.archive('v1');

      // Excluded by default
      expect(container.read(venturesProvider), isEmpty);
      expect(container.read(ventureProvider('v1'))?.isArchived, isTrue);

      // Included when filter is active
      container.read(showArchivedVenturesProvider.notifier).set(true);
      expect(container.read(venturesProvider).length, 1);

      // Restore
      vm.restore('v1');
      container.read(showArchivedVenturesProvider.notifier).set(false);
      expect(container.read(venturesProvider).length, 1);
      expect(container.read(ventureProvider('v1'))?.isArchived, isFalse);
    });
  });

  group('Venture Edit and Archive - SQLite persistence & Child safety', () {
    test(
      'archiving does not delete child hypotheses, experiments or evidence',
      () {
        final db = AppDatabase.inMemory();
        addTearDown(db.dispose);
        final ventures = SqliteVentureRepository(db);
        final discover = SqliteDiscoverRepository(db);
        final now = DateTime.now();

        ventures.add(
          Venture(
            id: 'v_sql',
            name: 'SQL Girişimi',
            problem: 'P',
            audience: 'A',
            createdAt: now,
          ),
        );
        discover.addHypothesis(
          Hypothesis(
            id: 'h_sql',
            ventureId: 'v_sql',
            statement: 'Çocuk kayıt testi',
            createdAt: now,
          ),
        );

        expect(ventures.all().length, 1);
        expect(discover.hypotheses('v_sql').length, 1);

        // Archive venture
        ventures.archive('v_sql');
        expect(ventures.all(), isEmpty);
        expect(ventures.all(includeArchived: true).length, 1);
        expect(ventures.find('v_sql')?.isArchived, isTrue);

        // Child records MUST be preserved
        expect(discover.hypotheses('v_sql').length, 1);
        expect(
          discover.hypotheses('v_sql').first.statement,
          'Çocuk kayıt testi',
        );

        // Update venture
        ventures.update(
          ventures.find('v_sql')!.copyWith(name: 'Güncellenmiş SQL Girişimi'),
        );
        expect(ventures.find('v_sql')?.name, 'Güncellenmiş SQL Girişimi');

        // Restore venture
        ventures.restore('v_sql');
        expect(ventures.all().length, 1);
        expect(ventures.find('v_sql')?.isArchived, isFalse);
        expect(discover.hypotheses('v_sql').length, 1);
      },
    );
  });
}
