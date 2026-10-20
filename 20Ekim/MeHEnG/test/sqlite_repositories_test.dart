import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/core/database/app_database.dart';
import 'package:meheng/features/ventures/data/sqlite_venture_repository.dart';
import 'package:meheng/features/ventures/domain/venture.dart';
import 'package:meheng/features/discover/data/sqlite_discover_repository.dart';
import 'package:meheng/features/discover/domain/hypothesis.dart';
import 'package:meheng/features/discover/domain/experiment.dart';
import 'package:meheng/features/discover/domain/evidence.dart';

void main() {
  test('private venture and evidence chain persist in SQLite', () {
    final db = AppDatabase.inMemory();
    addTearDown(db.dispose);
    final ventures = SqliteVentureRepository(db);
    final discover = SqliteDiscoverRepository(db);
    final now = DateTime.now();
    ventures.add(
      Venture(
        id: 'v1',
        name: 'Test girişimi',
        problem: 'Bir problem',
        audience: 'Müşteri',
        createdAt: now,
      ),
    );
    discover.addHypothesis(
      Hypothesis(
        id: 'h1',
        ventureId: 'v1',
        statement: 'İnsanlar buna ödeme yapar',
        createdAt: now,
      ),
    );
    discover.addExperiment(
      Experiment(
        id: 'x1',
        hypothesisId: 'h1',
        title: 'Görüşme',
        method: '10 müşteri ile konuş',
        createdAt: now,
      ),
    );
    discover.addEvidence(
      Evidence(
        id: 'e1',
        experimentId: 'x1',
        note: 'İlk müşteri kabul etmedi.',
        direction: EvidenceDirection.contradicts,
        createdAt: now,
      ),
    );
    expect(ventures.all().single.name, 'Test girişimi');
    expect(discover.hypotheses('v1').single.id, 'h1');
    expect(discover.experiments('h1').single.id, 'x1');
    expect(ventures.find('v1')?.name, 'Test girişimi');
    expect(ventures.find('missing-id'), isNull);
    expect(
      discover.evidence('x1').single.direction,
      EvidenceDirection.contradicts,
    );
    expect(db.db.select('PRAGMA user_version').first.values.first, 3);
  });

  test('SQLite correctly stores and restores all evidence directions', () {
    final db = AppDatabase.inMemory();
    addTearDown(db.dispose);
    final ventures = SqliteVentureRepository(db);
    final discover = SqliteDiscoverRepository(db);
    final now = DateTime.now();
    ventures.add(
      Venture(
        id: 'v2',
        name: 'Girişim 2',
        problem: 'P',
        audience: 'A',
        createdAt: now,
      ),
    );
    discover.addHypothesis(
      Hypothesis(id: 'h2', ventureId: 'v2', statement: 'H2', createdAt: now),
    );
    discover.addExperiment(
      Experiment(
        id: 'x2',
        hypothesisId: 'h2',
        title: 'X2',
        method: 'M2',
        createdAt: now,
      ),
    );
    discover.addEvidence(
      Evidence(
        id: 'e_sup',
        experimentId: 'x2',
        note: 'Destekleyici kanıt',
        direction: EvidenceDirection.supports,
        createdAt: now,
      ),
    );
    discover.addEvidence(
      Evidence(
        id: 'e_neu',
        experimentId: 'x2',
        note: 'Nötr kanıt',
        direction: EvidenceDirection.neutral,
        createdAt: now.add(const Duration(seconds: 1)),
      ),
    );

    final evList = discover.evidence('x2');
    expect(evList.length, 2);
    expect(
      evList.any((e) => e.direction == EvidenceDirection.supports),
      isTrue,
    );
    expect(evList.any((e) => e.direction == EvidenceDirection.neutral), isTrue);
  });

  test('SQLite enforces foreign key constraints', () {
    final db = AppDatabase.inMemory();
    addTearDown(db.dispose);
    expect(
      () => SqliteDiscoverRepository(db).addHypothesis(
        Hypothesis(
          id: 'bad',
          ventureId: 'missing',
          statement: 'X',
          createdAt: DateTime.now(),
        ),
      ),
      throwsException,
    );
  });
}
