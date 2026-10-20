import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/core/database/app_database.dart';
import 'package:meheng/core/database/schema_v1.dart';
import 'package:meheng/features/discover/data/sqlite_discover_repository.dart';
import 'package:meheng/features/discover/domain/evidence.dart';
import 'package:meheng/features/ventures/data/sqlite_venture_repository.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v1 -> v2', () {
    test('preserves all legacy records and seamlessly migrates to schema v2', () {
      final tempDir = Directory.systemTemp.createTempSync('meheng_mig_test_');
      final dbPath = '${tempDir.path}/test_v1.db';
      addTearDown(() {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      });

      // 1. Create a true v1 SQLite file on disk
      final rawDb = sqlite3.open(dbPath);
      rawDb.execute('PRAGMA foreign_keys = ON');
      createSchemaV1(rawDb);
      rawDb.execute('PRAGMA user_version = 1');

      final now = DateTime.now();
      rawDb.execute(
        'INSERT INTO ventures (id, name, problem, audience, created_at, is_archived) VALUES (?, ?, ?, ?, ?, ?)',
        [
          'v1',
          'Legacy Venture',
          'Old Prob',
          'Old Aud',
          now.microsecondsSinceEpoch,
          0,
        ],
      );
      rawDb.execute(
        'INSERT INTO hypotheses (id, venture_id, statement, created_at) VALUES (?, ?, ?, ?)',
        ['h1', 'v1', 'Old Hypothesis', now.microsecondsSinceEpoch],
      );
      rawDb.execute(
        'INSERT INTO experiments (id, hypothesis_id, title, method, created_at) VALUES (?, ?, ?, ?, ?)',
        ['x1', 'h1', 'Old Exp', 'Old Method', now.microsecondsSinceEpoch],
      );
      rawDb.execute(
        'INSERT INTO evidence (id, experiment_id, note, direction, created_at) VALUES (?, ?, ?, ?, ?)',
        [
          'e1',
          'x1',
          'Old observation without source',
          'supports',
          now.microsecondsSinceEpoch,
        ],
      );
      rawDb.close();

      // 2. Open through AppDatabase.open - triggers v1 -> v2 migration
      final appDb = AppDatabase.open(dbPath);
      addTearDown(appDb.dispose);

      // Verify user_version upgraded to current schema version (3)
      final version =
          appDb.db.select('PRAGMA user_version').first.values.first as int;
      expect(version, 3);

      // Verify all legacy v1 records were preserved intact
      final ventures = SqliteVentureRepository(appDb);
      final discover = SqliteDiscoverRepository(appDb);

      final legacyVenture = ventures.find('v1');
      expect(legacyVenture, isNotNull);
      expect(legacyVenture?.name, 'Legacy Venture');

      final legacyEvidence = discover.evidence('x1');
      expect(legacyEvidence.length, 1);
      expect(legacyEvidence.first.note, 'Old observation without source');
      expect(legacyEvidence.first.source, isNull);
      expect(legacyEvidence.first.hasConsent, isTrue);

      // 3. Add new v2 evidence with source and consent
      discover.addEvidence(
        Evidence(
          id: 'e2',
          experimentId: 'x1',
          note: 'Yeni mülakat kanıtı',
          direction: EvidenceDirection.contradicts,
          createdAt: now,
          source: 'Müşteri Görüşmesi #4',
          recordedAt: now,
          hasConsent: true,
        ),
      );

      final allEvidence = discover.evidence('x1');
      expect(allEvidence.length, 2);
      final newEv = allEvidence.firstWhere((e) => e.id == 'e2');
      expect(newEv.source, 'Müşteri Görüşmesi #4');
      expect(newEv.direction, EvidenceDirection.contradicts);
      expect(newEv.hasConsent, isTrue);
    });
  });
}
