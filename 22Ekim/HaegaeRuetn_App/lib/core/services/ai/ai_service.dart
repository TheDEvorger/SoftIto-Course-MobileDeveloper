import '../../models/habit.dart';
import 'ai_message.dart';
import 'ai_persona.dart';

/// Interface for AI services (Cloud repository or offline fallback).
abstract class AiService {
  Future<AiMessage> sendMessage({
    required List<AiMessage> history,
    required AiPersona persona,
    required String userPrompt,
    required List<Habit> availableHabits,
    String? contextSummary,
    bool plainTurkish = false,
    String? customInstructions,
  });
}
