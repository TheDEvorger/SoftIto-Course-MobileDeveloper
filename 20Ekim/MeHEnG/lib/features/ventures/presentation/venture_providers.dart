import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/ids/new_id.dart';
import '../data/sqlite_venture_repository.dart';
import '../domain/venture.dart';
import '../domain/venture_repository.dart';

final ventureRepositoryProvider = Provider<VentureRepository>(
  (ref) => SqliteVentureRepository(ref.watch(databaseProvider)),
);

final showArchivedVenturesProvider =
    NotifierProvider<ShowArchivedNotifier, bool>(ShowArchivedNotifier.new);

class ShowArchivedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

final venturesProvider = Provider<List<Venture>>((ref) {
  final showArchived = ref.watch(showArchivedVenturesProvider);
  return ref
      .watch(ventureRepositoryProvider)
      .all(includeArchived: showArchived);
});

final ventureProvider = Provider.family<Venture?, String>(
  (ref, id) => ref.watch(ventureRepositoryProvider).find(id),
);

final ventureViewModelProvider = Provider<VentureViewModel>(
  (ref) => VentureViewModel(ref),
);

class VentureViewModel {
  VentureViewModel(this.ref);
  final Ref ref;

  void create({
    required String name,
    required String problem,
    required String audience,
  }) {
    final error = Venture.validateName(name);
    if (error != null) throw ArgumentError(error);
    ref
        .read(ventureRepositoryProvider)
        .add(
          Venture(
            id: newId(),
            name: name.trim(),
            problem: problem.trim(),
            audience: audience.trim(),
            createdAt: DateTime.now(),
          ),
        );
    ref.invalidate(venturesProvider);
  }

  void update({
    required String id,
    required String name,
    required String problem,
    required String audience,
  }) {
    final error = Venture.validateName(name);
    if (error != null) throw ArgumentError(error);
    final repo = ref.read(ventureRepositoryProvider);
    final current = repo.find(id);
    if (current == null) throw StateError('Girişim bulunamadı.');

    repo.update(
      current.copyWith(
        name: name.trim(),
        problem: problem.trim(),
        audience: audience.trim(),
      ),
    );
    ref.invalidate(venturesProvider);
    ref.invalidate(ventureProvider(id));
  }

  void archive(String id) {
    ref.read(ventureRepositoryProvider).archive(id);
    ref.invalidate(venturesProvider);
    ref.invalidate(ventureProvider(id));
  }

  void restore(String id) {
    ref.read(ventureRepositoryProvider).restore(id);
    ref.invalidate(venturesProvider);
    ref.invalidate(ventureProvider(id));
  }
}
