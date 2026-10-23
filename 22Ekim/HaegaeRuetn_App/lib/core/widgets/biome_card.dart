import 'package:flutter/material.dart';

import '../models/era.dart';
import '../theme/realm_theme.dart';
import 'ornate_widgets.dart';

/// Fantasy biome data detailing visual lore and emblems for the 6 ages.
class BiomeData {
  const BiomeData({
    required this.romanNumber,
    required this.biomeName,
    required this.description,
    required this.motifIcon,
    required this.rankIcons,
  });

  final String romanNumber;
  final String biomeName;
  final String description;
  final IconData motifIcon;
  final List<IconData> rankIcons;

  static const biomes = <BiomeData>[
    BiomeData(
      romanNumber: 'I',
      biomeName: 'Zümrüt Vadi & Şafak Ormanı',
      description:
          'Sisli zümrüt vadilerde ilk kıvılcım parlar; küçük adımlar yeşerir.',
      motifIcon: Icons.wb_sunny_rounded,
      rankIcons: [
        Icons.local_fire_department_rounded,
        Icons.eco_rounded,
        Icons.hiking_rounded,
        Icons.explore_rounded,
      ],
    ),
    BiomeData(
      romanNumber: 'II',
      biomeName: 'Mavi Kuleler & Yemin Şehri',
      description:
          'Kâtipler divanı ve taş kütüphaneler. Sözler fermanla mühürlenir.',
      motifIcon: Icons.auto_stories_rounded,
      rankIcons: [
        Icons.edit_note_rounded,
        Icons.receipt_long_rounded,
        Icons.verified_rounded,
        Icons.history_edu_rounded,
      ],
    ),
    BiomeData(
      romanNumber: 'III',
      biomeName: 'Kadim Yaban & Rüzgarlı Geçit',
      description:
          'Fırtınalı dağ yolları ve yaban patikalar. Yol uzundur, çizme sağlam.',
      motifIcon: Icons.navigation_rounded,
      rankIcons: [
        Icons.pets_rounded,
        Icons.terrain_rounded,
        Icons.flag_circle_rounded,
        Icons.military_tech_rounded,
      ],
    ),
    BiomeData(
      romanNumber: 'IV',
      biomeName: 'Ametist Hisar & Muhafız Kalesi',
      description:
          'Aşılmaz mor burçlar ve çelik kalkanlar. Sarsılmaz irade diyarı.',
      motifIcon: Icons.shield_rounded,
      rankIcons: [
        Icons.security_rounded,
        Icons.shield_outlined,
        Icons.sports_kabaddi_rounded,
        Icons.fort_rounded,
      ],
    ),
    BiomeData(
      romanNumber: 'V',
      biomeName: 'Gül Bahçeleri & Beylik Kasrı',
      description:
          'Bereketli ovalar, taştan şatolar ve altın hasat. Bir çentikten bir kaleye.',
      motifIcon: Icons.castle_rounded,
      rankIcons: [
        Icons.foundation_rounded,
        Icons.cottage_rounded,
        Icons.domain_rounded,
        Icons.location_city_rounded,
      ],
    ),
    BiomeData(
      romanNumber: 'VI',
      biomeName: 'Göksel Saray & Taht Zirvesi',
      description:
          'Bulutların üzerinde altın kubbe ve ebedi taht. 24 seviyenin nihai tacı.',
      motifIcon: Icons.workspace_premium_rounded,
      rankIcons: [
        Icons.groups_rounded,
        Icons.diamond_rounded,
        Icons.gavel_rounded,
        Icons.workspace_premium_rounded,
      ],
    ),
  ];
}

/// Ornate, richly decorated card representing a kingdom biome / age.
class BiomeCard extends StatelessWidget {
  const BiomeCard({
    super.key,
    required this.index,
    required this.era,
    required this.userLevel,
    this.onTap,
  });

  final int index;
  final Era era;
  final int userLevel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final first = index * 4 + 1;
    final last = first + 3;
    final isActive = userLevel >= first && userLevel <= last;
    final isConquered = userLevel > last;
    final isLocked = userLevel < first;

    final biome = BiomeData.biomes[index.clamp(0, BiomeData.biomes.length - 1)];

    return OrnateCard(
      padding: const EdgeInsets.all(14),
      color: isActive
          ? Color.lerp(era.secondary, Colors.white, 0.45)!
          : isConquered
              ? Color.lerp(era.secondary, const Color(0xFFF9F6ED), 0.75)!
              : const Color(0xFFF3EFE6),
      borderColor: isActive
          ? era.accent
          : isConquered
              ? const Color(0xFFC8BA9B)
              : const Color(0xFFDED8CA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Biome Roman Numeral Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isLocked
                        ? [const Color(0xFF88867E), const Color(0xFF5F5D56)]
                        : [
                            Color.lerp(era.primary, Colors.white, 0.25)!,
                            era.primary,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive ? era.accent : const Color(0xFFDCC898),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          era.primary.withValues(alpha: isActive ? 0.35 : 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    biome.romanNumber,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${era.name} Çağı',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: isLocked
                                      ? const Color(0xFF7A776D)
                                      : RealmPalette.ink,
                                ),
                          ),
                        ),
                        _buildStatusBadge(isActive, isConquered, isLocked),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      biome.biomeName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLocked ? const Color(0xFF8E8B81) : era.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            biome.description,
            style: const TextStyle(
                fontSize: 11.5, height: 1.35, color: Color(0xFF595449)),
          ),
          const SizedBox(height: 10),
          const HeraldicDivider(),
          const SizedBox(height: 4),
          // Four Ranks in this Biome
          Row(
            children: List.generate(4, (rIndex) {
              final rankLevel = first + rIndex;
              final isRankAchieved = userLevel >= rankLevel;
              final isCurrentRank = userLevel == rankLevel;
              final rankName = era.ranks[rIndex];
              final rankIcon = rIndex < biome.rankIcons.length
                  ? biome.rankIcons[rIndex]
                  : Icons.shield_outlined;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: rIndex < 3 ? 6 : 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isCurrentRank
                        ? era.accent.withValues(alpha: 0.35)
                        : isRankAchieved
                            ? Colors.white.withValues(alpha: 0.8)
                            : const Color(0xFFE9E5DC).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isCurrentRank
                          ? era.primary
                          : isRankAchieved
                              ? const Color(0xFFDCC898)
                              : const Color(0xFFDDD8CE),
                      width: isCurrentRank ? 1.4 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        rankIcon,
                        size: 16,
                        color: isRankAchieved
                            ? era.primary
                            : const Color(0xFF9E9B91),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Lv.$rankLevel',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: isRankAchieved
                              ? RealmPalette.ink
                              : const Color(0xFF8D8A80),
                        ),
                      ),
                      Text(
                        rankName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight:
                              isCurrentRank ? FontWeight.w900 : FontWeight.w600,
                          color: isRankAchieved
                              ? RealmPalette.ink
                              : const Color(0xFF8D8A80),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive, bool isConquered, bool isLocked) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: era.accent.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC49A28)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 11, color: Color(0xFF4A3402)),
            SizedBox(width: 4),
            Text(
              'AKTİF BİYOM',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4A3402),
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      );
    }
    if (isConquered) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFE2F4EA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF8FCFA9)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 11, color: Color(0xFF1B6B3E)),
            SizedBox(width: 4),
            Text(
              'AŞILDI',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1B6B3E),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E3D8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCCC5B3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 10, color: Color(0xFF787467)),
          SizedBox(width: 3),
          Text(
            'KİLİTLİ',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Color(0xFF787467),
            ),
          ),
        ],
      ),
    );
  }
}
