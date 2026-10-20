import 'package:meheng/features/ventures/domain/venture.dart';
import 'package:meheng/features/ventures/domain/venture_repository.dart';

class FakeVentureRepository implements VentureRepository {
  final List<Venture> _items = [];

  @override
  List<Venture> all({bool includeArchived = false}) {
    final filtered = includeArchived
        ? _items
        : _items.where((v) => !v.isArchived).toList();
    return List.unmodifiable(
      [...filtered]..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  @override
  Venture? find(String id) {
    try {
      return _items.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(Venture venture) {
    _items.add(venture);
  }

  @override
  void update(Venture venture) {
    final idx = _items.indexWhere((v) => v.id == venture.id);
    if (idx != -1) {
      _items[idx] = venture;
    }
  }

  @override
  void archive(String id) {
    final idx = _items.indexWhere((v) => v.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(isArchived: true);
    }
  }

  @override
  void restore(String id) {
    final idx = _items.indexWhere((v) => v.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(isArchived: false);
    }
  }

  void clear() => _items.clear();
}
