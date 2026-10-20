import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ids/new_id.dart';
import '../domain/hypothesis.dart';
import '../domain/experiment.dart';
import '../domain/evidence.dart';
import '../domain/decision.dart';
import 'discover_providers.dart';

final discoverViewModelProvider = Provider<DiscoverViewModel>(
  (ref) => DiscoverViewModel(ref),
);

class DiscoverViewModel {
  DiscoverViewModel(this.ref);
  final Ref ref;

  void addHypothesis(String ventureId, String text) {
    if (text.trim().length < 5) {
      throw ArgumentError('En az 5 karakter gerekli.');
    }
    ref.read(discoverRepositoryProvider).addHypothesis(
          Hypothesis(
            id: newId(),
            ventureId: ventureId,
            statement: text.trim(),
            createdAt: DateTime.now(),
          ),
        );
    ref.invalidate(hypothesesProvider(ventureId));
  }

  void addExperiment(String hypothesisId, String title, String method) {
    if (title.trim().length < 3 || method.trim().length < 3) {
      throw ArgumentError('Başlık ve yöntem en az 3 karakter olmalı.');
    }
    ref.read(discoverRepositoryProvider).addExperiment(
          Experiment(
            id: newId(),
            hypothesisId: hypothesisId,
            title: title.trim(),
            method: method.trim(),
            createdAt: DateTime.now(),
          ),
        );
    ref.invalidate(experimentsProvider(hypothesisId));
  }

  void addEvidence(
    String experimentId,
    String note,
    EvidenceDirection direction, {
    String? source,
    DateTime? recordedAt,
    bool hasConsent = true,
  }) {
    if (note.trim().length < 5) {
      throw ArgumentError('Gözlem en az 5 karakter olmalı.');
    }
    ref.read(discoverRepositoryProvider).addEvidence(
          Evidence(
            id: newId(),
            experimentId: experimentId,
            note: note.trim(),
            direction: direction,
            createdAt: DateTime.now(),
            source: source?.trim().isEmpty == true ? null : source?.trim(),
            recordedAt: recordedAt,
            hasConsent: hasConsent,
          ),
        );
    ref.invalidate(evidenceProvider(experimentId));
  }

  void addDecision({
    required String ventureId,
    required DecisionOutcome outcome,
    required String rationale,
    required List<String> evidenceIds,
    String? hypothesisId,
  }) {
    if (rationale.trim().length < 5) {
      throw ArgumentError('Karar gerekçesi en az 5 karakter olmalı.');
    }
    ref.read(discoverRepositoryProvider).addDecision(
          Decision(
            id: newId(),
            ventureId: ventureId,
            hypothesisId: hypothesisId,
            outcome: outcome,
            rationale: rationale.trim(),
            evidenceIds: List.unmodifiable(evidenceIds),
            createdAt: DateTime.now(),
          ),
        );
    ref.invalidate(decisionsProvider(ventureId));
  }
}
