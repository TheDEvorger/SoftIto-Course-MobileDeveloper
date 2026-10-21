class GardenSceneData {
  const GardenSceneData({
    required this.id,
    required this.name,
    required this.slug,
    required this.usage,
    required this.description,
    required this.assetPath,
  });

  final String id;
  final String name;
  final String slug;
  final String usage;
  final String description;
  final String assetPath;
}

abstract final class GardenScenes {
  static const sunrise = 'assets/illustrations/scenes/01_garden_sunrise.webp';
  static const river = 'assets/illustrations/scenes/02_river_grove.webp';
  static const clearing = 'assets/illustrations/scenes/03_forest_clearing.webp';
  static const glasshouse = 'assets/illustrations/scenes/04_glasshouse.webp';
  static const valley = 'assets/illustrations/scenes/05_mountain_valley.webp';
  static const moon = 'assets/illustrations/scenes/06_moon_garden.webp';
  static const terrace = 'assets/illustrations/scenes/07_golden_terrace.webp';
  static const waterfall =
      'assets/illustrations/scenes/08_emerald_waterfall.webp';
  static const cottage = 'assets/illustrations/scenes/09_study_cottage.webp';
  static const rainbow = 'assets/illustrations/scenes/10_rainbow_garden.webp';

  static const all = <GardenSceneData>[
    GardenSceneData(
      id: 'SCENE-01',
      name: 'Gün Doğumunda Kır Evi',
      slug: 'garden_sunrise',
      usage: 'Ana sayfa / karşılama',
      description: 'Sabah vadisi, kır evi ve bereketli bahçe',
      assetPath: sunrise,
    ),
    GardenSceneData(
      id: 'SCENE-02',
      name: 'Orman Nehri',
      slug: 'river_grove',
      usage: 'Günlük plan / ferahlık',
      description: 'Yeşil ağaçlar ve turkuaz akarsu',
      assetPath: river,
    ),
    GardenSceneData(
      id: 'SCENE-03',
      name: 'Fenerli Orman Açıklığı',
      slug: 'forest_clearing',
      usage: 'Odak öncesi / başarı',
      description: 'Işık süzülen orman ve asılı fenerler',
      assetPath: clearing,
    ),
    GardenSceneData(
      id: 'SCENE-04',
      name: 'Botanik Kış Bahçesi',
      slug: 'glasshouse',
      usage: 'Konular / öğrenme odası',
      description: 'Sarmaşıklar, ahşap raf ve güneşli çalışma mekânı',
      assetPath: glasshouse,
    ),
    GardenSceneData(
      id: 'SCENE-05',
      name: 'Dağ Vadisi',
      slug: 'mountain_valley',
      usage: 'İlerleme ve hedefler',
      description: 'Çiçekli patika, dağ ve göl panoraması',
      assetPath: valley,
    ),
    GardenSceneData(
      id: 'SCENE-06',
      name: 'Ay Işığı Bahçesi',
      slug: 'moon_garden',
      usage: 'Koyu tema / gece odak',
      description: 'Mor gece, altın fenerler, nilüfer gölü',
      assetPath: moon,
    ),
    GardenSceneData(
      id: 'SCENE-07',
      name: 'Altın Saat Terası',
      slug: 'golden_terrace',
      usage: 'Motivasyon / profil',
      description: 'Limon ağaçları ve sıcak taş teras',
      assetPath: terrace,
    ),
    GardenSceneData(
      id: 'SCENE-08',
      name: 'Zümrüt Şelaleler',
      slug: 'emerald_waterfall',
      usage: 'Konu haritası / keşif',
      description: 'Canlı turkuaz havuzlar ve katmanlı şelaleler',
      assetPath: waterfall,
    ),
    GardenSceneData(
      id: 'SCENE-09',
      name: 'Orman Çalışma Kulübesi',
      slug: 'study_cottage',
      usage: 'Pomodoro / odak',
      description: 'Orman evinin çalışma masası, altın ışık',
      assetPath: cottage,
    ),
    GardenSceneData(
      id: 'SCENE-10',
      name: 'Yağmur Sonrası Bahçe',
      slug: 'rainbow_garden',
      usage: 'Başarı / ilerleme',
      description: 'Islak yapraklar, hafif gökkuşağı, parlak taş yol',
      assetPath: rainbow,
    ),
  ];
}
