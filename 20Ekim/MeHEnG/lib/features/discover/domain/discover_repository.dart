import 'hypothesis.dart';
import 'experiment.dart';
import 'evidence.dart';
import 'decision.dart';

abstract class DiscoverRepository {
  List<Hypothesis> hypotheses(String ventureId);
  List<Experiment> experiments(String hypothesisId);
  List<Evidence> evidence(String experimentId);
  List<Decision> decisions(String ventureId);
  void addHypothesis(Hypothesis item);
  void addExperiment(Experiment item);
  void addEvidence(Evidence item);
  void addDecision(Decision item);
}
