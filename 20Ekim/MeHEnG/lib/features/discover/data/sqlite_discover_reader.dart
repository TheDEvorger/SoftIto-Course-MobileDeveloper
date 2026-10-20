import 'dart:convert';
import 'package:sqlite3/sqlite3.dart';
import '../../../core/database/app_database.dart';
import '../domain/hypothesis.dart';
import '../domain/experiment.dart';
import '../domain/evidence.dart';
import '../domain/decision.dart';

class SqliteDiscoverReader {
  SqliteDiscoverReader(this.database);
  final AppDatabase database;

  List<Hypothesis> hypotheses(String id) => database.db
      .select(
        'SELECT * FROM hypotheses WHERE venture_id=? ORDER BY created_at DESC',
        [id],
      )
      .map(
        (r) => Hypothesis(
          id: r['id'] as String,
          ventureId: r['venture_id'] as String,
          statement: r['statement'] as String,
          createdAt: DateTime.fromMicrosecondsSinceEpoch(
            r['created_at'] as int,
          ),
        ),
      )
      .toList();

  List<Experiment> experiments(String id) => database.db
      .select(
        'SELECT * FROM experiments WHERE hypothesis_id=? ORDER BY created_at DESC',
        [id],
      )
      .map(
        (r) => Experiment(
          id: r['id'] as String,
          hypothesisId: r['hypothesis_id'] as String,
          title: r['title'] as String,
          method: r['method'] as String,
          createdAt: DateTime.fromMicrosecondsSinceEpoch(
            r['created_at'] as int,
          ),
        ),
      )
      .toList();

  List<Evidence> evidence(String id) => database.db
      .select(
        'SELECT * FROM evidence WHERE experiment_id=? ORDER BY created_at DESC',
        [id],
      )
      .map(_decodeEvidence)
      .toList();

  List<Decision> decisions(String ventureId) => database.db
      .select(
        'SELECT * FROM decisions WHERE venture_id=? ORDER BY created_at DESC',
        [ventureId],
      )
      .map(_decodeDecision)
      .toList();

  Evidence _decodeEvidence(Row r) => Evidence(
        id: r['id'] as String,
        experimentId: r['experiment_id'] as String,
        note: r['note'] as String,
        direction: EvidenceDirection.values.byName(r['direction'] as String),
        createdAt: DateTime.fromMicrosecondsSinceEpoch(r['created_at'] as int),
        source: r['source'] as String?,
        recordedAt: r['recorded_at'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(r['recorded_at'] as int)
            : null,
        hasConsent: (r['has_consent'] as int? ?? 1) == 1,
      );

  Decision _decodeDecision(Row r) => Decision(
        id: r['id'] as String,
        ventureId: r['venture_id'] as String,
        hypothesisId: r['hypothesis_id'] as String?,
        outcome: DecisionOutcome.values.byName(r['outcome'] as String),
        rationale: r['rationale'] as String,
        evidenceIds: List<String>.from(
          jsonDecode(r['evidence_ids'] as String) as List,
        ),
        createdAt: DateTime.fromMicrosecondsSinceEpoch(r['created_at'] as int),
      );
}
