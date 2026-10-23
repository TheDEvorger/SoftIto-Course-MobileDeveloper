import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../state/realm_controller.dart';
import 'ai_context_builder.dart';
import 'ai_error_handler.dart';
import 'ai_message.dart';
import 'ai_persona.dart';
import 'ai_service.dart';
import 'groq_ai_repository.dart';

/// State controller for the Bilge Rehber AI chat screen.
class AiChatController extends ChangeNotifier {
  AiChatController({AiService? service})
      : _service = service ?? GroqAiRepository();

  AiService _service;
  AiService get service => _service;

  static const _prefWorkerUrl = 'haegaruuetn_ai_worker_url';
  static const _prefShareContext = 'haegaruuetn_ai_share_context';
  static const _prefPlainTurkish = 'haegaruuetn_ai_plain_turkish';
  static const _prefPersona = 'haegaruuetn_ai_persona';
  static const _prefCustomInstructions = 'haegaruuetn_ai_custom_instructions';

  final List<AiMessage> _messages = [
    AiMessage(
      id: 'welcome',
      role: AiRole.assistant,
      content:
          'Hoş geldin yolcu. Ben krallığın Bilge Rehberi. Bir hedef seç, birlikte ilk küçük adımı bulalım.',
      timestamp: DateTime.now(),
      isOfflineFallback: true,
    ),
  ];

  List<AiMessage> get messages => List.unmodifiable(_messages);

  AiPersonaType _personaType = AiPersonaType.companion;
  AiPersonaType get personaType => _personaType;
  AiPersona get currentPersona => AiPersona.fromType(_personaType);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _currentError;
  String? get currentError => _currentError;

  bool _shareHabitContext = false;
  bool get shareHabitContext => _shareHabitContext;

  bool _usePlainTurkish = false;
  bool get usePlainTurkish => _usePlainTurkish;

  String? _customInstructions;
  String? get customInstructions => _customInstructions;

  String _workerUrl = '';
  String get workerUrl => _workerUrl;

  bool get isCloudConnected =>
      _workerUrl.trim().isNotEmpty && _workerUrl.startsWith('http');

  String? _lastFailedPrompt;

  final _contextBuilder = const AiContextBuilder();

  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _workerUrl = prefs.getString(_prefWorkerUrl) ?? '';
      _shareHabitContext = prefs.getBool(_prefShareContext) ?? false;
      _usePlainTurkish = prefs.getBool(_prefPlainTurkish) ?? false;
      _customInstructions = prefs.getString(_prefCustomInstructions);

      final savedPersona = prefs.getString(_prefPersona);
      if (savedPersona != null) {
        _personaType = AiPersonaType.values.firstWhere(
          (p) => p.name == savedPersona,
          orElse: () => AiPersonaType.companion,
        );
      }

      _rebuildService();
      notifyListeners();
    } catch (_) {}
  }

  void _rebuildService() {
    _service =
        GroqAiRepository(workerUrl: _workerUrl.isEmpty ? null : _workerUrl);
  }

  void setWorkerUrl(String url) async {
    _workerUrl = url.trim();
    _rebuildService();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefWorkerUrl, _workerUrl);
  }

  void setPersona(AiPersonaType type) async {
    _personaType = type;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefPersona, type.name);
  }

  void toggleShareHabitContext(bool value) async {
    _shareHabitContext = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefShareContext, value);
  }

  void togglePlainTurkish(bool value) async {
    _usePlainTurkish = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefPlainTurkish, value);
  }

  void setCustomInstructions(String? text) async {
    _customInstructions = text?.trim().isEmpty == true ? null : text?.trim();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (_customInstructions == null) {
      await prefs.remove(_prefCustomInstructions);
    } else {
      await prefs.setString(_prefCustomInstructions, _customInstructions!);
    }
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      AiMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: AiRole.assistant,
        content:
            'Sohbet defteri temizlendi. ${currentPersona.name} yeni fermanların için hazır!',
        timestamp: DateTime.now(),
        isOfflineFallback: !isCloudConnected,
      ),
    );
    _currentError = null;
    _lastFailedPrompt = null;
    notifyListeners();
  }

  Future<void> sendMessage(
      String text, RealmController? realmController) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isLoading) return;

    _lastFailedPrompt = trimmed;
    _currentError = null;

    final userMessage = AiMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: AiRole.user,
      content: trimmed,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final contextSummary = realmController != null
          ? _contextBuilder.buildContext(
              controller: realmController,
              consentGranted: _shareHabitContext,
            )
          : null;

      final reply = await _service.sendMessage(
        history: _messages.where((m) => !m.isError).toList(),
        persona: currentPersona,
        userPrompt: trimmed,
        availableHabits: realmController?.activeHabits ?? [],
        contextSummary: contextSummary,
        plainTurkish: _usePlainTurkish,
        customInstructions: _customInstructions,
      );

      _messages.add(reply);
      _lastFailedPrompt = null;
    } on AiException catch (e) {
      _currentError = e.message;
      _messages.add(
        AiMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: AiRole.assistant,
          content: '⚠️ ${e.message}',
          timestamp: DateTime.now(),
          isError: true,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      _currentError = 'Beklenmeyen bir aksaklık oluştu: $e';
      _messages.add(
        AiMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: AiRole.assistant,
          content: '⚠️ Beklenmeyen bir aksaklık oluştu. Lütfen tekrar deneyin.',
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryLast(RealmController? realmController) async {
    if (_lastFailedPrompt == null || _isLoading) return;
    // Remove last error message if present
    if (_messages.isNotEmpty && _messages.last.isError) {
      _messages.removeLast();
    }
    // Remove last user prompt if present because sendMessage will re-add it
    if (_messages.isNotEmpty &&
        _messages.last.isUser &&
        _messages.last.content == _lastFailedPrompt) {
      _messages.removeLast();
    }
    final promptToRetry = _lastFailedPrompt!;
    _lastFailedPrompt = null;
    await sendMessage(promptToRetry, realmController);
  }
}
