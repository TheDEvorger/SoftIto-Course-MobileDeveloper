import 'package:flutter_test/flutter_test.dart';
import 'package:venaflow/data/demo/demo_clinic_store.dart';
import 'package:venaflow/data/models/collection_status.dart';
import 'package:venaflow/data/models/collection_visit.dart';
import 'package:venaflow/features/queue_management/controllers/queue_controller.dart';

void main() {
  group('DemoClinicStore Testleri', () {
    test('Yeni hasta kaydı benzersiz sıra numarası üretir', () {
      final DemoClinicStore store = DemoClinicStore();
      final int initialCount = store.current.visits.length;
      final int nextQueue = store.current.nextQueueNumber;

      final CollectionVisit visit = store.registerPatient(
        displayName: 'Test Hastası',
        code: 'DEMO-999',
        department: 'Biyokimya',
      );

      expect(visit.queueNumber, equals(nextQueue));
      expect(store.current.visits.length, equals(initialCount + 1));
      expect(visit.status, equals(CollectionStatus.waiting));
    });

    test('Hasta çağırma ve adım adım durum akışı kuralı', () {
      final DemoClinicStore store = DemoClinicStore();
      final CollectionVisit? called = store.callNext();

      expect(called, isNotNull);
      expect(called!.status, equals(CollectionStatus.called));

      // called -> inProgress
      final bool advanced = store.advance(called.id);
      expect(advanced, isTrue);
      expect(
          store.current.visitById(called.id)?.status, equals(CollectionStatus.inProgress));

      // inProgress -> sampleCollected
      store.advance(called.id);
      expect(store.current.visitById(called.id)?.status,
          equals(CollectionStatus.sampleCollected));

      // sampleCollected -> delivered
      store.advance(called.id);
      expect(store.current.visitById(called.id)?.status,
          equals(CollectionStatus.delivered));

      // delivered durumundan sonra advance false dönmeli
      expect(store.advance(called.id), isFalse);
    });

    test('İşlemi geri alma (undo) ve demoyu sıfırlama (reset)', () {
      final DemoClinicStore store = DemoClinicStore();
      final int initialCount = store.current.visits.length;

      final CollectionVisit visit = store.registerPatient(
        displayName: 'Geçici Hasta',
        code: 'DEMO-888',
        department: 'Hematoloji',
      );
      expect(store.current.visits.length, equals(initialCount + 1));

      // Durum değişikliğini test edelim
      store.advance(visit.id);
      expect(store.current.visitById(visit.id)?.status, equals(CollectionStatus.called));

      // Undo
      expect(store.canUndo.value, isTrue);
      final bool undone = store.undo();
      expect(undone, isTrue);
      expect(store.current.visitById(visit.id)?.status, equals(CollectionStatus.waiting));

      // Reset
      store.reset();
      expect(store.current.visits.any((CollectionVisit v) => v.id == visit.id), isFalse);
    });
  });

  group('QueueController Arama & Filtreleme Testi', () {
    test('Filtre ve arama doğru sonuç üretir', () {
      final DemoClinicStore store = DemoClinicStore();
      final List<CollectionVisit> all =
          QueueController.apply(store.current, query: '', filter: null);
      expect(all.length, equals(store.current.visits.length));

      final List<CollectionVisit> waiting = QueueController.apply(
        store.current,
        query: '',
        filter: CollectionStatus.waiting,
      );
      expect(
        waiting.every((CollectionVisit v) => v.status == CollectionStatus.waiting),
        isTrue,
      );
    });
  });
}
