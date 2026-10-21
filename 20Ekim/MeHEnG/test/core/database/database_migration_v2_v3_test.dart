import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:meheng/core/database/app_database.dart';
import 'package:meheng/core/database/schema_v2.dart';
import 'package:meheng/features/discover/data/sqlite_discover_repository.dart';
import 'package:meheng/features/discover/domain/decision.dart';
import 'package:meheng/features/ventures/data/sqlite_venture_repository.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  group('Database Migration v2 -> v3', () {
    test('preserves all legacy records and seamlessly migrates to schema v3 with decisions', () {
      final tempDir = Directory.systemTemp.createTempSync('meheng_mig_v2_v3_');
      final dbPath = '${tempDir.path}/test_v2.db';
      addTearDown(() {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      });

      // 1. Create a true v2 SQLite file on disk
      final rawDb = sqlite3.open(dbPath);
      rawDb.execute('PRAGMA foreign_keys = ON');
      createSchemaV2(rawDb);
      rawDb.execute('PRAGMA user_version = 2');

      final now = DateTime.now();
      rawDb.execute(
        'INSERT INTO ventures (id, name, problem, audience, created_at, is_archived) VALUES (?, ?, ?, ?, ?, ?)',
        ['v_mig', 'Venture V2', 'Problem V2', 'Audience V2', now.microsecondsSinceEpoch, 0],
      );
      rawDb.execute(
        'INSERT INTO hypotheses (id, venture_id, statement, created_at) VALUES (?, ?, ?, ?)',
        ['h_mig', 'v_mig', 'Hypothesis V2', now.microsecondsSinceEpoch],
      );
      rawDb.execute(
        'INSERT INTO experiments (id, hypothesis_id, title, method, created_at) VALUES (?, ?, ?, ?, ?)',
        ['x_mig', 'h_mig', 'Exp V2', 'Method V2', now.microsecondsSinceEpoch],
      );
      rawDb.execute(
        '''INSERT INTO evidence (id, experiment_id, note, direction, created_at, source, recorded_at, has_consent)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
        [
          'e_mig',
          'x_mig',
          'Observation V2',
          'supports',
          now.microsecondsSinceEpoch,
          'User Interview #1',
          now.microsecondsSinceEpoch,
          1,
        ],
      );
      rawDb.close();

      // 2. Open through AppDatabase.open - triggers v2 -> v3 migration
      final appDb = AppDatabase.open(dbPath);
      addTearDown(appDb.dispose);

      // Verify user_version upgraded to 3
      final version = appDb.db.select('PRAGMA user_version').first.values.first as int;
      expect(version, 3);

      // Verify legacy records intact
      final ventures = SqliteVentureRepository(appDb);
      final discover = SqliteDiscoverRepository(appDb);

      expect(ventures.find('v_mig')?.name, 'Venture V2');
      final evidenceList = discover.evidence('x_mig');
      expect(evidenceList.length, 1);
      expect(evidenceList.first.source, 'User Interview #1');
      expect(evidenceList.first.hasConsent, isTrue);

      // 3. Insert decision linked to legacy evidence
      discover.addDecision(
        Decision(
          id: 'dec_1',
          ventureId: 'v_mig',
          outcome: DecisionOutcome.pivot,
          rationale: 'Müşteri görüşmesi #1 doğrultusunda pivot kararı alındı.',
          evidenceIds: ['e_mig'],
          createdAt: now,
        ),
      );

      final decisions = discover.decisions('v_mig');
      expect(decisions.length, 1);
      expect(decisions.first.id, 'dec_1');
      expect(decisions.first.outcome, DecisionOutcome.pivot);
      expect(decisions.first.evidenceIds, ['e_mig']);
    });
  });
}
