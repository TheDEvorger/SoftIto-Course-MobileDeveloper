import 'venture.dart';

abstract class VentureRepository {
  List<Venture> all({bool includeArchived = false});
  Venture? find(String id);
  void add(Venture venture);
  void update(Venture venture);
  void archive(String id);
  void restore(String id);
}
