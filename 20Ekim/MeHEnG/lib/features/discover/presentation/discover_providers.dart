import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_provider.dart';
import '../data/sqlite_discover_repository.dart';
import '../domain/discover_repository.dart';
import '../domain/hypothesis.dart';
import '../domain/experiment.dart';
import '../domain/evidence.dart';
import '../domain/decision.dart';

final discoverRepositoryProvider = Provider<DiscoverRepository>(
  (ref) => SqliteDiscoverRepository(ref.watch(databaseProvider)),
);

final hypothesesProvider = Provider.family<List<Hypothesis>, String>(
  (ref, ventureId) =>
      ref.watch(discoverRepositoryProvider).hypotheses(ventureId),
);

final experimentsProvider = Provider.family<List<Experiment>, String>(
  (ref, hypothesisId) =>
      ref.watch(discoverRepositoryProvider).experiments(hypothesisId),
);

final evidenceProvider = Provider.family<List<Evidence>, String>(
  (ref, experimentId) =>
      ref.watch(discoverRepositoryProvider).evidence(experimentId),
);

final decisionsProvider = Provider.family<List<Decision>, String>(
  (ref, ventureId) =>
      ref.watch(discoverRepositoryProvider).decisions(ventureId),
);
