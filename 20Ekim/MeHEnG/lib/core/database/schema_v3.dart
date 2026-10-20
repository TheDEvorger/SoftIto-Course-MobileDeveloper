import 'package:sqlite3/sqlite3.dart';

void createSchemaV3(Database db) {
  db.execute('''CREATE TABLE ventures (
    id TEXT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    problem TEXT NOT NULL,
    audience TEXT NOT NULL,
    created_at INTEGER NOT NULL,
    is_archived INTEGER NOT NULL DEFAULT 0
  )''');
  db.execute('''CREATE TABLE hypotheses (
    id TEXT PRIMARY KEY NOT NULL,
    venture_id TEXT NOT NULL REFERENCES ventures(id) ON DELETE CASCADE,
    statement TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''');
  db.execute('''CREATE TABLE experiments (
    id TEXT PRIMARY KEY NOT NULL,
    hypothesis_id TEXT NOT NULL REFERENCES hypotheses(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    method TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''');
  db.execute('''CREATE TABLE evidence (
    id TEXT PRIMARY KEY NOT NULL,
    experiment_id TEXT NOT NULL REFERENCES experiments(id) ON DELETE CASCADE,
    note TEXT NOT NULL,
    direction TEXT NOT NULL CHECK(direction IN ('supports','contradicts','neutral')),
    created_at INTEGER NOT NULL,
    source TEXT,
    recorded_at INTEGER,
    has_consent INTEGER NOT NULL DEFAULT 1
  )''');
  db.execute('''CREATE TABLE decisions (
    id TEXT PRIMARY KEY NOT NULL,
    venture_id TEXT NOT NULL REFERENCES ventures(id) ON DELETE CASCADE,
    hypothesis_id TEXT,
    outcome TEXT NOT NULL CHECK(outcome IN ('continueRun','pivot','stop')),
    rationale TEXT NOT NULL,
    evidence_ids TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''');
  db.execute('CREATE INDEX idx_hypotheses_venture ON hypotheses(venture_id)');
  db.execute(
    'CREATE INDEX idx_experiments_hypothesis ON experiments(hypothesis_id)',
  );
  db.execute('CREATE INDEX idx_evidence_experiment ON evidence(experiment_id)');
  db.execute('CREATE INDEX idx_decisions_venture ON decisions(venture_id)');
}

void migrateV2ToV3(Database db) {
  db.execute('''CREATE TABLE decisions (
    id TEXT PRIMARY KEY NOT NULL,
    venture_id TEXT NOT NULL REFERENCES ventures(id) ON DELETE CASCADE,
    hypothesis_id TEXT,
    outcome TEXT NOT NULL CHECK(outcome IN ('continueRun','pivot','stop')),
    rationale TEXT NOT NULL,
    evidence_ids TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''');
  db.execute('CREATE INDEX idx_decisions_venture ON decisions(venture_id)');
}
