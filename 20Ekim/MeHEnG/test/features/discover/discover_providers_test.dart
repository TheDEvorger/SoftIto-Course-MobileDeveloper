import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/features/discover/domain/evidence.dart';
import 'package:meheng/features/discover/presentation/discover_providers.dart';
import 'package:meheng/features/discover/presentation/discover_view_model.dart';
import '../../fakes/fake_discover_repository.dart';

void main() {
  late FakeDiscoverRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeDiscoverRepository();
    container = ProviderContainer(
      overrides: [discoverRepositoryProvider.overrideWithValue(fakeRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Discover Providers & ViewModel - Hypotheses', () {
    test('initial state has empty hypotheses', () {
      expect(container.read(hypothesesProvider('v1')), isEmpty);
    });

    test('addHypothesis succeeds and invalidates hypothesesProvider', () {
      final vm = container.read(discoverViewModelProvider);

      vm.addHypothesis('v1', '  Müşteriler hızlı çözüme ödeme yapacaktır  ');

      final list = container.read(hypothesesProvider('v1'));
      expect(list.length, 1);
      expect(list.first.statement, 'Müşteriler hızlı çözüme ödeme yapacaktır');
      expect(list.first.ventureId, 'v1');
    });

    test('addHypothesis throws ArgumentError on short input (< 5 chars)', () {
      final vm = container.read(discoverViewModelProvider);

      expect(() => vm.addHypothesis('v1', 'kısa'), throwsArgumentError);
      expect(() => vm.addHypothesis('v1', '   '), throwsArgumentError);
    });
  });

  group('Discover Providers & ViewModel - Experiments', () {
    test('initial state has empty experiments', () {
      expect(container.read(experimentsProvider('h1')), isEmpty);
    });

    test('addExperiment succeeds and invalidates experimentsProvider', () {
      final vm = container.read(discoverViewModelProvider);

      vm.addExperiment(
        'h1',
        '  Kullanıcı Görüşmesi  ',
        '  Birebir 15 dk mülakat  ',
      );

      final list = container.read(experimentsProvider('h1'));
      expect(list.length, 1);
      expect(list.first.title, 'Kullanıcı Görüşmesi');
      expect(list.first.method, 'Birebir 15 dk mülakat');
      expect(list.first.hypothesisId, 'h1');
    });

    test('addExperiment throws ArgumentError on short title or method', () {
      final vm = container.read(discoverViewModelProvider);

      expect(
        () => vm.addExperiment('h1', 'ab', 'Geçerli yöntem'),
        throwsArgumentError,
      );
      expect(
        () => vm.addExperiment('h1', 'Geçerli başlık', 'ab'),
        throwsArgumentError,
      );
      expect(() => vm.addExperiment('h1', '   ', '   '), throwsArgumentError);
    });
  });

  group('Discover Providers & ViewModel - Evidence', () {
    test('initial state has empty evidence', () {
      expect(container.read(evidenceProvider('e1')), isEmpty);
    });

    test('addEvidence succeeds for all direction states', () {
      final vm = container.read(discoverViewModelProvider);

      vm.addEvidence(
        'x1',
        '5 kişi satın alma taahhüdü verdi.',
        EvidenceDirection.supports,
      );
      vm.addEvidence(
        'x1',
        '2 kişi fiyatı yüksek buldu.',
        EvidenceDirection.contradicts,
      );
      vm.addEvidence('x1', '3 kişi karar veremedi.', EvidenceDirection.neutral);

      final list = container.read(evidenceProvider('x1'));
      expect(list.length, 3);
      expect(
        list.any((e) => e.direction == EvidenceDirection.supports),
        isTrue,
      );
      expect(
        list.any((e) => e.direction == EvidenceDirection.contradicts),
        isTrue,
      );
      expect(list.any((e) => e.direction == EvidenceDirection.neutral), isTrue);
    });

    test('addEvidence throws ArgumentError on short note (< 5 chars)', () {
      final vm = container.read(discoverViewModelProvider);

      expect(
        () => vm.addEvidence('x1', 'kısa', EvidenceDirection.supports),
        throwsArgumentError,
      );
      expect(
        () => vm.addEvidence('x1', '    ', EvidenceDirection.supports),
        throwsArgumentError,
      );
    });
  });
}
