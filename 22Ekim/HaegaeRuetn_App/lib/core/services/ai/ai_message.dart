import 'pact_suggestion.dart';

enum AiRole { user, assistant, system }

/// Represents a single message in the Bilge Rehber chat session.
class AiMessage {
  const AiMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.pactSuggestion,
    this.isOfflineFallback = false,
    this.isError = false,
    this.errorMessage,
  });

  final String id;
  final AiRole role;
  final String content;
  final DateTime timestamp;
  final PactSuggestion? pactSuggestion;
  final bool isOfflineFallback;
  final bool isError;
  final String? errorMessage;

  bool get isUser => role == AiRole.user;
  bool get isAssistant => role == AiRole.assistant;

  AiMessage copyWith({
    String? content,
    PactSuggestion? pactSuggestion,
    bool? isOfflineFallback,
    bool? isError,
    String? errorMessage,
  }) =>
      AiMessage(
        id: id,
        role: role,
        content: content ?? this.content,
        timestamp: timestamp,
        pactSuggestion: pactSuggestion ?? this.pactSuggestion,
        isOfflineFallback: isOfflineFallback ?? this.isOfflineFallback,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        if (pactSuggestion != null) 'pactSuggestion': pactSuggestion!.toJson(),
        'isOfflineFallback': isOfflineFallback,
        'isError': isError,
        if (errorMessage != null) 'errorMessage': errorMessage,
      };

  factory AiMessage.fromJson(Map<String, dynamic> json) => AiMessage(
        id: json['id'] as String? ??
            DateTime.now().microsecondsSinceEpoch.toString(),
        role: AiRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => AiRole.assistant,
        ),
        content: json['content'] as String? ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now(),
        pactSuggestion: json['pactSuggestion'] != null
            ? PactSuggestion.fromJson(
                Map<String, dynamic>.from(json['pactSuggestion'] as Map))
            : null,
        isOfflineFallback: json['isOfflineFallback'] as bool? ?? false,
        isError: json['isError'] as bool? ?? false,
        errorMessage: json['errorMessage'] as String?,
      );
}
