import 'dart:convert';
import '../../../core/database/app_database.dart';
import '../domain/hypothesis.dart';
import '../domain/experiment.dart';
import '../domain/evidence.dart';
import '../domain/decision.dart';
import '../domain/discover_repository.dart';
import 'sqlite_discover_reader.dart';

class SqliteDiscoverRepository implements DiscoverRepository {
  SqliteDiscoverRepository(this.database)
      : reader = SqliteDiscoverReader(database);
  final AppDatabase database;
  final SqliteDiscoverReader reader;

  @override
  List<Hypothesis> hypotheses(String id) => reader.hypotheses(id);

  @override
  List<Experiment> experiments(String id) => reader.experiments(id);

  @override
  List<Evidence> evidence(String id) => reader.evidence(id);

  @override
  List<Decision> decisions(String ventureId) => reader.decisions(ventureId);

  @override
  void addHypothesis(Hypothesis item) => database.db.execute(
        'INSERT INTO hypotheses (id,venture_id,statement,created_at) VALUES (?,?,?,?)',
        [
          item.id,
          item.ventureId,
          item.statement,
          item.createdAt.microsecondsSinceEpoch,
        ],
      );

  @override
  void addExperiment(Experiment item) => database.db.execute(
        'INSERT INTO experiments (id,hypothesis_id,title,method,created_at) VALUES (?,?,?,?,?)',
        [
          item.id,
          item.hypothesisId,
          item.title,
          item.method,
          item.createdAt.microsecondsSinceEpoch,
        ],
      );

  @override
  void addEvidence(Evidence item) => database.db.execute(
        '''INSERT INTO evidence (id,experiment_id,note,direction,created_at,source,recorded_at,has_consent)
           VALUES (?,?,?,?,?,?,?,?)''',
        [
          item.id,
          item.experimentId,
          item.note,
          item.direction.name,
          item.createdAt.microsecondsSinceEpoch,
          item.source,
          item.recordedAt?.microsecondsSinceEpoch,
          item.hasConsent ? 1 : 0,
        ],
      );

  @override
  void addDecision(Decision item) => database.db.execute(
        '''INSERT INTO decisions (id,venture_id,hypothesis_id,outcome,rationale,evidence_ids,created_at)
           VALUES (?,?,?,?,?,?,?)''',
        [
          item.id,
          item.ventureId,
          item.hypothesisId,
          item.outcome.name,
          item.rationale,
          jsonEncode(item.evidenceIds),
          item.createdAt.microsecondsSinceEpoch,
        ],
      );
}
