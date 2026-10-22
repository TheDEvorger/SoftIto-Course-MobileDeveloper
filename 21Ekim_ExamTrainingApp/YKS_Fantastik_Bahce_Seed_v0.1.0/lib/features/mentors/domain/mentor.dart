class FantasyMentor {
  const FantasyMentor({
    required this.id,
    required this.name,
    required this.title,
    required this.subject,
    required this.avatarAsset,
    required this.catchphrase,
    required this.liveLessonTitle,
    required this.isLiveNow,
    required this.lessonTime,
    required this.lessonSummary,
    required this.wisdomQuote,
    required this.specialtyTags,
    required this.suggestedQuestions,
  });

  final String id;
  final String name;
  final String title;
  final String subject;
  final String avatarAsset;
  final String catchphrase;
  final String liveLessonTitle;
  final bool isLiveNow;
  final String lessonTime;
  final String lessonSummary;
  final String wisdomQuote;
  final List<String> specialtyTags;
  final List<String> suggestedQuestions;

  static const List<FantasyMentor> allMentors = [
    FantasyMentor(
      id: 'theron',
      name: 'Archmage Theron',
      title: 'Sayısal Büyüleri & Kadim Geometri Üstadı',
      subject: 'Matematik & Geometri',
      avatarAsset: 'assets/illustrations/mentors/mentor_theron.jpg',
      catchphrase: 'Türev ve integral, evrenin kadim denge mühürleridir.',
      liveLessonTitle: 'Türev Büyüsü ile Maksimum-Minimum Düğümlerini Çözme',
      isLiveNow: true,
      lessonTime: 'Şimdi Yayında (1.420 Aday İzliyor)',
      lessonSummary:
          'Fonksiyonların teğet eğimlerini ve grafik tepe noktalarını geometrik ışık mühürleriyle adım adım inceliyoruz.',
      wisdomQuote:
          'Gözün korkmasın evlat; en karmaşık polinom bile doğru çarpanlara ayrıldığında bir su damlası gibi berraklaşır.',
      specialtyTags: ['Türev', 'Trigonometri', 'Analitik Geometri', 'Problemler'],
      suggestedQuestions: [
        'Hocam, limit ve süreklilikte en çok nerede hata yapılıyor?',
        'Trigonometri formüllerini aklımda tutmanın büyülü bir yolu var mı?',
        'Geometride görme yeteneğini nasıl geliştiririm?',
      ],
    ),
    FantasyMentor(
      id: 'sylva',
      name: 'Bilge Sylva',
      title: 'Doğa Ruhları & Hücre Büyücüsü',
      subject: 'Biyoloji & Canlı Bilimleri',
      avatarAsset: 'assets/illustrations/mentors/mentor_sylva.jpg',
      catchphrase: 'Bahçemizdeki her filiz, hücre bölünmesinin saf mucizesidir.',
      liveLessonTitle: 'Kalıtım ve Ekoloji: Genetik Düğümleri Çözme Seansı',
      isLiveNow: true,
      lessonTime: 'Şimdi Yayında (980 Aday İzliyor)',
      lessonSummary:
          'Mendel genetiği, kan grupları ve ekosistem madde döngülerini canlı bitki kristalleri üzerinden keşfediyoruz.',
      wisdomQuote:
          'Canlılık bir rekabet değil, mükemmel bir uyumdur. Tıpkı düzenli soru çözerek zihnini besleyen bir tohum gibi.',
      specialtyTags: ['Kalıtım', 'Fotosentez', 'Hücre Bölünmesi', 'Sistemler'],
      suggestedQuestions: [
        'Hocam, fotosentez ve solunum reaksiyonlarını nasıl karıştırmam?',
        'Kalıtım çaprazlamalarında pratik yöntem var mı?',
        'Biyoloji ezber mi yoksa mantık mı?',
      ],
    ),
    FantasyMentor(
      id: 'ignis',
      name: 'Simyacı Ignis',
      title: 'Enerji Dönüşümleri & Element Efendisi',
      subject: 'Fizik & Kimya',
      avatarAsset: 'assets/illustrations/mentors/mentor_ignis.jpg',
      catchphrase: 'Kuvvet ve tepkime; ateş ile aklın kusursuz kıvılcımıdır.',
      liveLessonTitle: 'Elektromanyetizma & Gaz Yasaları Simya Laboratuvarı',
      isLiveNow: false,
      lessonTime: 'Bugün 20:30 (Canlı Deney)',
      lessonSummary:
          'Manyetik alan kuvvet çizgilerini plazma kürelerinde gözlemleyip ideal gaz denklemini kıvılcımlarla patlatıyoruz!',
      wisdomQuote:
          'Enerji asla yok olmaz; sadece doğru çalışma disipliniyle hedefine ulaşan bir vektöre dönüşür!',
      specialtyTags: ['Bağıl Hareket', 'Elektrik', 'Kimyasal Denge', 'Organik'],
      suggestedQuestions: [
        'İtme-Momentum sorularında yön hatalarını nasıl engellerim?',
        'Kimyasal dengede Le Chatelier ilkesini nasıl kafama kazırım?',
        'Elektrik devrelerinde potansiyel fark bulma taktiği nedir?',
      ],
    ),
    FantasyMentor(
      id: 'valerius',
      name: 'Ozan Valerius',
      title: 'Kelimelerin Büyücüsü & Kadim Tarihçi',
      subject: 'Türkçe, Edebiyat & Sosyal',
      avatarAsset: 'assets/illustrations/mentors/mentor_valerius.jpg',
      catchphrase: 'Kelimeler kılıçtan keskindir; paragrafı anlayan sınavı büker.',
      liveLessonTitle: '30 Saniyede Paragraf Ana Düşüncesini Mühürleme',
      isLiveNow: false,
      lessonTime: 'Yarın 19:00',
      lessonSummary:
          'Paragraf metinlerinde yazarın gizlediği ipucu kelimeleri sezme ve akış bozan cümleleri tek hamlede eleme sanatı.',
      wisdomQuote:
          'Okumak, başkasının zihninde güvenle yolculuk yapmaktır. Metnin kalbine odaklanırsan seçenekler sana teslim olur.',
      specialtyTags: ['Paragraf Taktikleri', 'Divan Edebiyatı', 'Tarih', 'Felsefe'],
      suggestedQuestions: [
        'Paragrafta iki şık arasında kalınca hangisini seçmeliyim?',
        'Cumhuriyet Dönemi yazarlarını karıştırmamak için ne yapmalıyım?',
        'Uzun sorularda dikkatim dağılıyor, odaklanma tüyosu var mı?',
      ],
    ),
  ];
}
