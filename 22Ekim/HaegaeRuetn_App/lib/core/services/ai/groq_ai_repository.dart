import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/habit.dart';
import '../guide_service.dart';
import 'ai_error_handler.dart';
import 'ai_message.dart';
import 'ai_persona.dart';
import 'ai_service.dart';
import 'pact_suggestion.dart';

/// GroqCloud AI repository via Cloudflare Worker proxy.
/// Never stores API keys directly on client.
class GroqAiRepository implements AiService {
  GroqAiRepository({
    this.workerUrl,
    this.clientSecret,
    http.Client? httpClient,
    GuideService? fallbackService,
    this.model = primaryModel,
  })  : _client = httpClient ?? http.Client(),
        _fallback = fallbackService ?? OfflineGuideService();

  static const primaryModel = 'qwen/qwen3.8-27b';
  static const fallbackModel = 'openai/gpt-oss-20b';

  final String? workerUrl;
  final String? clientSecret;
  final String model;
  final http.Client _client;
  final GuideService _fallback;

  bool get isConfigured =>
      workerUrl != null &&
      workerUrl!.trim().isNotEmpty &&
      workerUrl!.startsWith('http');

  @override
  Future<AiMessage> sendMessage({
    required List<AiMessage> history,
    required AiPersona persona,
    required String userPrompt,
    required List<Habit> availableHabits,
    String? contextSummary,
    bool plainTurkish = false,
    String? customInstructions,
  }) async {
    // 1. If worker URL is not configured, gracefully use the OfflineGuideService prototype
    if (!isConfigured) {
      return _generateOfflineFallback(persona, userPrompt, availableHabits);
    }

    // 2. Build system prompt & message payload
    final systemPrompt = persona.buildSystemPrompt(
      plainTurkish: plainTurkish,
      customInstructions: customInstructions,
      habitContext: contextSummary,
    );

    final apiMessages = <Map<String, String>>[
      {'role': 'system', 'content': systemPrompt},
      // Include last 6 messages from history for compact context
      ...history.take(6).map((m) => {
            'role': m.isUser ? 'user' : 'assistant',
            'content': m.content,
          }),
      {'role': 'user', 'content': userPrompt},
    ];

    final requestBody = jsonEncode({
      'model': model,
      'messages': apiMessages,
      'temperature': 0.7,
      'max_tokens': 600,
    });

    final headers = {
      'Content-Type': 'application/json',
      'X-App-Id': 'haegaruuetn-v1',
      if (clientSecret != null && clientSecret!.isNotEmpty)
        'X-Hager-Client-Secret': clientSecret!,
    };

    // 3. Send HTTP request to Cloudflare Worker
    http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(workerUrl!),
            headers: headers,
            body: requestBody,
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw const AiException(
        code: AiErrorCode.timeout,
        message:
            'Kraliyet ulağı zamanında dönemedi (zaman aşımı). Lütfen tekrar deneyin.',
      );
    } catch (e) {
      throw AiException(
        code: AiErrorCode.networkError,
        message:
            'Ağ bağlantısı kurulamadı. İnternet bağlantınızı kontrol edin.',
        technicalDetails: e.toString(),
      );
    }

    // 4. Handle HTTP responses
    if (response.statusCode != 200) {
      String? serverMsg;
      try {
        final errJson = jsonDecode(response.body);
        serverMsg = errJson['error']?['message'] as String?;
      } catch (_) {}
      throw AiException.fromStatusCode(response.statusCode, serverMsg);
    }

    // 5. Parse response content
    try {
      final data =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw const AiException(
          code: AiErrorCode.invalidResponse,
          message: 'Yapay zekâdan boş yanıt alındı.',
        );
      }

      final messageMap = choices[0]['message'] as Map<String, dynamic>?;
      final rawContent = (messageMap?['content'] as String?)?.trim() ?? '';

      if (rawContent.isEmpty) {
        throw const AiException(
          code: AiErrorCode.invalidResponse,
          message: 'Yapay zekâ mesajı boş döndü.',
        );
      }

      // 6. Extract structured PactSuggestion if any
      final suggestion = PactSuggestion.tryExtract(rawContent, availableHabits);
      final displayContent = suggestion != null
          ? PactSuggestion.cleanDisplayMessage(rawContent)
          : rawContent;

      return AiMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: AiRole.assistant,
        content: displayContent.isEmpty
            ? 'Sana bir ahit önerisi hazırladım:'
            : displayContent,
        timestamp: DateTime.now(),
        pactSuggestion: suggestion,
        isOfflineFallback: false,
      );
    } on AiException {
      rethrow;
    } catch (e) {
      throw AiException(
        code: AiErrorCode.invalidResponse,
        message: 'Model çıktısı çözümlenemedi.',
        technicalDetails: e.toString(),
      );
    }
  }

  AiMessage _generateOfflineFallback(
    AiPersona persona,
    String userPrompt,
    List<Habit> availableHabits,
  ) {
    final tone = switch (persona.type) {
      AiPersonaType.commander => GuideTone.commander,
      AiPersonaType.sage => GuideTone.sage,
      AiPersonaType.companion => GuideTone.companion,
    };
    final reply = _fallback.reply(userPrompt, tone);
    return AiMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: AiRole.assistant,
      content: reply,
      timestamp: DateTime.now(),
      isOfflineFallback: true,
    );
  }
}
