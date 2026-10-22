import 'package:flutter/material.dart';

import '../../../core/theme/garden_palette.dart';
import '../domain/mentor.dart';
import 'live_lesson_dialog.dart';

class MentorsScreen extends StatelessWidget {
  const MentorsScreen({super.key});

  void _openLiveLesson(BuildContext context, FantasyMentor mentor) {
    showDialog<void>(
      context: context,
      builder: (_) => LiveLessonDialog(mentor: mentor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = GardenPalette.mossEmerald;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kadim Akademi & Canlı Dersler'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Karşılama ve Atmosfer Başlığı
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1B2B20), const Color(0xFF101B14)]
                    : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: primary, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fantastik Akademi Salonu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : GardenPalette.inkPlum,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Bahçenin dört bir yanından gelen kadim YKS üstatları canlı yayınlarda ve soru-cevap seanslarında seni bekliyor!',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'BİLGE EĞİTMENLER & CANLI YAYINLAR',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),

          // Eğitmen Kartları
          ...FantasyMentor.allMentors.map((mentor) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141F18) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: mentor.isLiveNow
                      ? Colors.redAccent.withValues(alpha: 0.4)
                      : (isDark ? Colors.white10 : Colors.black12),
                  width: mentor.isLiveNow ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hoca Resmi ve Üst Bilgi
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Image.asset(
                            mentor.avatarAsset,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      // Karartma gradyanı
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Canlı Yayında Rozeti
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: mentor.isLiveNow ? Colors.redAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              if (mentor.isLiveNow)
                                BoxShadow(
                                  color: Colors.redAccent.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                mentor.isLiveNow
                                    ? Icons.fiber_manual_record
                                    : Icons.schedule,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                mentor.isLiveNow ? 'CANLI YAYINDA' : mentor.lessonTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Branş Rozeti
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            mentor.subject,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Resim üzerindeki alt isim
                      Positioned(
                        bottom: 12,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mentor.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              mentor.title,
                              style: TextStyle(
                                color: Colors.amber.shade200,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Açıklama ve Canlı Ders Başlığı
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bilgelik Sözü
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1D2B22) : const Color(0xFFF1F8F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.format_quote_rounded, color: Colors.amber, size: 20),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  mentor.wisdomQuote,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Canlı Ders Bilgisi
                        Text(
                          'Güncel Seans: ${mentor.liveLessonTitle}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : GardenPalette.inkPlum,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mentor.lessonSummary,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Uzmanlık Etiketleri
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: mentor.specialtyTags.map((tag) {
                            return Chip(
                              label: Text(tag, style: const TextStyle(fontSize: 10)),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                                  isDark ? const Color(0xFF1E2D24) : const Color(0xFFE8F1EB),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        // Eylem Butonları
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  mentor.isLiveNow ? Icons.play_arrow_rounded : Icons.forum_rounded,
                                  size: 18,
                                ),
                                label: Text(
                                  mentor.isLiveNow ? 'Canlı Derse Katıl' : 'Hocaya Soru Sor (AI)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      mentor.isLiveNow ? Colors.redAccent : primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () => _openLiveLesson(context, mentor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
