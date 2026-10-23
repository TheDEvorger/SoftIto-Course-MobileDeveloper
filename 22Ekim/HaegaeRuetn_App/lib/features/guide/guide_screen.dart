import 'package:flutter/material.dart';

import '../../core/services/ai/ai_chat_controller.dart';
import '../../core/services/ai/ai_message.dart';
import '../../core/services/ai/ai_persona.dart';
import '../../core/services/ai/groq_ai_repository.dart';
import '../../core/state/realm_controller.dart';
import '../../core/theme/realm_theme.dart';
import '../../core/widgets/ornate_widgets.dart';
import '../../core/widgets/realm_card.dart';
import 'guide_settings_sheet.dart';
import 'pact_suggestion_card.dart';

/// Bilge Rehber screen connected to GroqCloud via Cloudflare Worker proxy,
/// with offline prototype fallback and interactive pact suggestions.
class GuideScreen extends StatefulWidget {
  const GuideScreen({
    super.key,
    this.controller,
    this.chatController,
  });

  final RealmController? controller;
  final AiChatController? chatController;

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late final AiChatController _chat;
  bool _ownsChatController = false;

  @override
  void initState() {
    super.initState();
    if (widget.chatController != null) {
      _chat = widget.chatController!;
    } else {
      _chat = AiChatController();
      _ownsChatController = true;
      _chat.initialize();
    }
    _chat.addListener(_onChatUpdated);
  }

  void _onChatUpdated() {
    if (!mounted) return;
    setState(() {});
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chat.removeListener(_onChatUpdated);
    if (_ownsChatController) {
      _chat.dispose();
    }
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    _chat.sendMessage(text, widget.controller);
  }

  void _openSettings() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF9F5EC),
      builder: (_) => GuideSettingsSheet(controller: _chat),
    );
  }

  @override
  Widget build(BuildContext context) {
    final persona = _chat.currentPersona;

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            children: [
              const FancyHeroHeader(
                title: 'Bilge Rehber',
                subtitle:
                    'Ałek’ryŧhæ kadim arşivi, yapay zekâ danışmanı ve yol arkadaşın.',
                assetPath: ArtAssets.guide,
                height: 185,
              ),
              const SizedBox(height: 12),
              // Status & Settings Row
              Row(
                children: [
                  Expanded(
                    child: _chat.isCloudConnected
                        ? const RealmPill(
                            label:
                                'Bulut AI Aktif • ${GroqAiRepository.primaryModel}',
                            icon: Icons.cloud_done_rounded,
                            color: Color(0xFFE2F4EA),
                          )
                        : const RealmPill(
                            label: 'Çevrimdışı Prototip • Worker URL ekleyin',
                            icon: Icons.cloud_off_rounded,
                            color: Color(0xFFFFE8C7),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFDCC898)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, size: 20),
                      tooltip: 'Rehber Ayarları',
                      color: RealmPalette.ink,
                      onPressed: _openSettings,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Persona Choice Chips
              Wrap(
                spacing: 7,
                children: AiPersona.all.map((p) {
                  final isSelected = _chat.personaType == p.type;
                  return ChoiceChip(
                    avatar: Icon(
                      p.icon,
                      size: 16,
                      color: isSelected ? Colors.white : p.primaryColor,
                    ),
                    label: Text(p.name),
                    selected: isSelected,
                    selectedColor: p.primaryColor,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : RealmPalette.ink,
                    ),
                    onSelected: (_) => _chat.setPersona(p.type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              // Chat Messages
              ..._chat.messages.map((m) => _buildMessageBubble(m, persona)),
              // Loading / Generating Indicator
              if (_chat.isLoading) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFDFC57C)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(persona.primaryColor),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${persona.name} düşünüyor...',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: persona.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Input Area
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: 3,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: '${persona.name} ile konuş...',
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 11),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Gönder',
                onPressed: _send,
                icon: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(AiMessage message, AiPersona persona) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OrnateCard(
              color: const Color(0xFFE4F0EC),
              borderColor: const Color(0xFFB4D8CD),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              showCorners: false,
              child: Text(
                message.content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: RealmPalette.ink,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Assistant Message Bubble
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 345),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrnateCard(
                color: message.isError
                    ? const Color(0xFFFFF0F0)
                    : const Color(0xFFFFFDF8),
                borderColor: message.isError
                    ? const Color(0xFFEAA2A2)
                    : const Color(0xFFE0C988),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Persona & Source Badge Header
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(persona.icon,
                            size: 14, color: persona.primaryColor),
                        const SizedBox(width: 5),
                        Text(
                          persona.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: persona.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: message.isOfflineFallback
                                ? const Color(0xFFFFEDCE)
                                : const Color(0xFFE2F4EA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message.isOfflineFallback
                                ? 'Çevrimdışı'
                                : 'Groq AI',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: message.isOfflineFallback
                                  ? const Color(0xFF8B6415)
                                  : const Color(0xFF1B6B3E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: message.isError
                            ? const Color(0xFF942828)
                            : RealmPalette.ink,
                      ),
                    ),
                    if (message.isError) ...[
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Yeniden Dene'),
                        onPressed: () => _chat.retryLast(widget.controller),
                      ),
                    ],
                  ],
                ),
              ),
              // If model suggested an interactive pact, display the confirmation card
              if (message.pactSuggestion != null)
                PactSuggestionCard(
                  suggestion: message.pactSuggestion!,
                  realmController: widget.controller,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
