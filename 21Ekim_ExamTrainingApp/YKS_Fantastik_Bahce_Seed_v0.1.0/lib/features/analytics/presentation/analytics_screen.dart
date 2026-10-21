import 'package:flutter/material.dart';

import '../../../core/assets/garden_scenes.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../shared/widgets/garden_cards.dart';
import '../../../shared/widgets/garden_progress.dart';
import '../../../shared/widgets/seed_notice.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ForestHeroCard(
          assetPath: GardenScenes.valley,
          tag: '📊 Net ve Başarı Analizi',
          title: 'Gelişiminin Yolculuğu',
          subtitle: 'Grafiklerin, gerçek denemelerin geldikçe çiçek açacak.',
          height: 190,
        ),
        const SizedBox(height: 12),
        const SeedNotice(),
        const SizedBox(height: 12),
        const BotanicalSectionHeader(
          title: 'Net İlerleme Durumu',
          subtitle: 'Hedefe göre başarı yüzdesi',
          icon: Icons.trending_up,
        ),
        GardenCard(
          child: Row(
            children: [
              const OrganicProgressRing(
                progress: 0.0,
                size: 80,
                strokeWidth: 8,
                centerText: '0.0',
                subText: 'Net Ort.',
                activeColor: GardenPalette.mossEmerald,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Henüz Kayıtlı Deneme Yok',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'En az 2 deneme kaydettiğinde burada zaman bazlı net artışı ve çizgi grafikleri yer alacak.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const WaterInfoCard(
          title: 'Doğruluk ve Gerçekçi Ölçüm',
          message:
              'Fantastik Bahçe, sahte başarı veya uydurma veri göstermez. Deneme girdikçe ders bazlı gelişim analizleri TASK-007 ile bu ekranda çizilecektir.',
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
