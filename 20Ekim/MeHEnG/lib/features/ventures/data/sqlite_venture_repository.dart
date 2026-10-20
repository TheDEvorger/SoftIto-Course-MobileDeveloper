import 'package:sqlite3/sqlite3.dart';
import '../../../core/database/app_database.dart';
import '../domain/venture.dart';
import '../domain/venture_repository.dart';

class SqliteVentureRepository implements VentureRepository {
  SqliteVentureRepository(this.database);
  final AppDatabase database;

  Venture _decode(Row row) => Venture(
    id: row['id'] as String,
    name: row['name'] as String,
    problem: row['problem'] as String,
    audience: row['audience'] as String,
    createdAt: DateTime.fromMicrosecondsSinceEpoch(row['created_at'] as int),
    isArchived: (row['is_archived'] as int? ?? 0) == 1,
  );

  @override
  List<Venture> all({bool includeArchived = false}) {
    final sql = includeArchived
        ? 'SELECT * FROM ventures ORDER BY created_at DESC'
        : 'SELECT * FROM ventures WHERE is_archived = 0 ORDER BY created_at DESC';
    return database.db.select(sql).map(_decode).toList();
  }

  @override
  Venture? find(String id) {
    final rows = database.db.select('SELECT * FROM ventures WHERE id = ?', [
      id,
    ]);
    return rows.isEmpty ? null : _decode(rows.first);
  }

  @override
  void add(Venture venture) => database.db.execute(
    '''INSERT INTO ventures(id,name,problem,audience,created_at,is_archived)
           VALUES (?,?,?,?,?,?)''',
    [
      venture.id,
      venture.name,
      venture.problem,
      venture.audience,
      venture.createdAt.microsecondsSinceEpoch,
      venture.isArchived ? 1 : 0,
    ],
  );

  @override
  void update(Venture venture) => database.db.execute(
    '''UPDATE ventures SET name = ?, problem = ?, audience = ?, is_archived = ?
           WHERE id = ?''',
    [
      venture.name,
      venture.problem,
      venture.audience,
      venture.isArchived ? 1 : 0,
      venture.id,
    ],
  );

  @override
  void archive(String id) => database.db.execute(
    'UPDATE ventures SET is_archived = 1 WHERE id = ?',
    [id],
  );

  @override
  void restore(String id) => database.db.execute(
    'UPDATE ventures SET is_archived = 0 WHERE id = ?',
    [id],
  );
}
