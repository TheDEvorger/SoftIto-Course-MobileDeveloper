import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../domain/mentor.dart';
import '../domain/mentor_ai_service.dart';

class LiveLessonDialog extends StatefulWidget {
  const LiveLessonDialog({required this.mentor, super.key});

  final FantasyMentor mentor;

  @override
  State<LiveLessonDialog> createState() => _LiveLessonDialogState();
}

class _LiveLessonDialogState extends State<LiveLessonDialog> {
  final TextEditingController _questionController = TextEditingController();
  final List<_ChatMessage> _chatHistory = [];
  bool _isConsultingAi = false;

  @override
  void initState() {
    super.initState();
    _chatHistory.addAll([
      _ChatMessage(
        sender: widget.mentor.name,
        text: 'Kadim Akademi dersimize hoş geldin genç yolcu! ${widget.mentor.catchphrase}',
        isMentor: true,
      ),
      const _ChatMessage(
        sender: 'Sınav Yolcusu (Mert)',
        text: 'Hocam türev teğet eğimi sorusu geldiğinde ne yapıyoruz?',
        isMentor: false,
      ),
      _ChatMessage(
        sender: widget.mentor.name,
        text: 'Mert, harika bir soru! Şimdi tahtadaki ışık rünlerine odaklanın.',
        isMentor: true,
      ),
    ]);
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion(String question) async {
    final text = question.trim();
    if (text.isEmpty) return;

    _questionController.clear();
    setState(() {
      _chatHistory.add(_ChatMessage(sender: 'Sen', text: text, isMentor: false));
      _isConsultingAi = true;
    });

    try {
      final response = await MentorAiService.instance.askMentor(
        mentor: widget.mentor,
        userQuestion: text,
      );

      if (mounted) {
        setState(() {
          _isConsultingAi = false;
          _chatHistory.add(
            _ChatMessage(
              sender: widget.mentor.name,
              text: response.reply,
              isMentor: true,
              tacticHighlight: response.spellTactic,
            ),
          );
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isConsultingAi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = GardenPalette.mossEmerald;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: isDark ? const Color(0xFF141E18) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 600,
          height: 650,
          child: Column(
            children: [
              // Canlı Yayın Başlığı ve Canlı Rozeti
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: isDark ? const Color(0xFF0F1713) : GardenPalette.mossEmerald,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.fiber_manual_record, color: Colors.white, size: 10),
                          SizedBox(width: 4),
                          Text(
                            'CANLI AKADEMİ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.mentor.liveLessonTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Büyülü Canlı Ders Tahtası / Sahnesi
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.mentor.avatarAsset),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(widget.mentor.avatarAsset),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.mentor.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  widget.mentor.title,
                                  style: TextStyle(
                                    color: Colors.amber.shade200,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '🔮 Büyülü Taktik: ${widget.mentor.catchphrase}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Canlı Sohbet ve AI Soru-Cevap Akışı
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _chatHistory.length + (_isConsultingAi ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _chatHistory.length && _isConsultingAi) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage(widget.mentor.avatarAsset),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: primary),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Büyü rünleri fısıldanıyor...',
                                    style: TextStyle(color: primary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final msg = _chatHistory[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment:
                            msg.isMentor ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg.sender,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: msg.isMentor
                                  ? (isDark ? Colors.amber.shade300 : GardenPalette.mossEmerald)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 380),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: msg.isMentor
                                  ? (isDark ? const Color(0xFF1E2D24) : const Color(0xFFEAF5EE))
                                  : primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: msg.isMentor ? primary.withValues(alpha: 0.3) : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.35,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                if (msg.tacticHighlight != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.auto_awesome, color: Colors.amber, size: 14),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Mühür Tavsiye: ${msg.tacticHighlight}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Hızlı Örnek Sorular Çubuğu
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.mentor.suggestedQuestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final q = widget.mentor.suggestedQuestions[i];
                    return ActionChip(
                      label: Text(
                        q,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      backgroundColor: isDark ? const Color(0xFF1D2A22) : const Color(0xFFF0F4F1),
                      onPressed: () => _askQuestion(q),
                    );
                  },
                ),
              ),

              // Mesaj & Soru Gönderme Alanı
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: isDark ? const Color(0xFF0F1713) : const Color(0xFFF6FAF7),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _questionController,
                        onSubmitted: _askQuestion,
                        decoration: InputDecoration(
                          hintText: '${widget.mentor.name}\'a YKS sorusu sor...',
                          hintStyle: const TextStyle(fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          isDense: true,
                          filled: true,
                          fillColor: isDark ? const Color(0xFF1A261F) : Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: primary),
                      onPressed: () => _askQuestion(_questionController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.isMentor,
    this.tacticHighlight,
  });

  final String sender;
  final String text;
  final bool isMentor;
  final String? tacticHighlight;
}
