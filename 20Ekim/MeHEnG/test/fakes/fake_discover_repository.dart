import 'package:meheng/features/discover/domain/decision.dart';
import 'package:meheng/features/discover/domain/discover_repository.dart';
import 'package:meheng/features/discover/domain/evidence.dart';
import 'package:meheng/features/discover/domain/experiment.dart';
import 'package:meheng/features/discover/domain/hypothesis.dart';

class FakeDiscoverRepository implements DiscoverRepository {
  final List<Hypothesis> _hypotheses = [];
  final List<Experiment> _experiments = [];
  final List<Evidence> _evidence = [];
  final List<Decision> _decisions = [];

  @override
  List<Hypothesis> hypotheses(String ventureId) => List.unmodifiable(
        _hypotheses.where((h) => h.ventureId == ventureId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );

  @override
  List<Experiment> experiments(String hypothesisId) => List.unmodifiable(
        _experiments.where((e) => e.hypothesisId == hypothesisId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );

  @override
  List<Evidence> evidence(String experimentId) => List.unmodifiable(
        _evidence.where((e) => e.experimentId == experimentId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );

  @override
  List<Decision> decisions(String ventureId) => List.unmodifiable(
        _decisions.where((d) => d.ventureId == ventureId).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );

  @override
  void addHypothesis(Hypothesis item) => _hypotheses.add(item);

  @override
  void addExperiment(Experiment item) => _experiments.add(item);

  @override
  void addEvidence(Evidence item) => _evidence.add(item);

  @override
  void addDecision(Decision item) => _decisions.add(item);

  void clear() {
    _hypotheses.clear();
    _experiments.clear();
    _evidence.clear();
    _decisions.clear();
  }
}
