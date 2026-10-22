/// Puan simülasyonu alan türleri
enum SimulationField {
  sayisal('Sayısal (SAY)', 'TYT + Matematik + Fen'),
  esitAgirlik('Eşit Ağırlık (EA)', 'TYT + Matematik + Edebiyat-Sosyal'),
  sozel('Sözel (SÖZ)', 'TYT + Edebiyat-Sosyal-1 + Sosyal-2'),
  tytOnly('Yalnızca TYT', 'Temel Yeterlilik Testi');

  const SimulationField(this.title, this.description);
  final String title;
  final String description;
}

/// Simülasyon giriş verileri
class SimulationInput {
  const SimulationInput({
    this.field = SimulationField.sayisal,
    this.tytTurkce = 0.0,
    this.tytMatematik = 0.0,
    this.tytSosyal = 0.0,
    this.tytFen = 0.0,
    this.aytMatematik = 0.0,
    this.aytFizik = 0.0,
    this.aytKimya = 0.0,
    this.aytBiyoloji = 0.0,
    this.aytEdebiyat = 0.0,
    this.aytTarih1 = 0.0,
    this.aytCografya1 = 0.0,
    this.diplomaGrade = 80.0,
    this.isPreviousYearPlaced = false,
  });

  final SimulationField field;
  final double tytTurkce; // maks 40
  final double tytMatematik; // maks 40
  final double tytSosyal; // maks 20
  final double tytFen; // maks 20

  final double aytMatematik; // maks 40
  final double aytFizik; // maks 14
  final double aytKimya; // maks 13
  final double aytBiyoloji; // maks 13

  final double aytEdebiyat; // maks 24
  final double aytTarih1; // maks 10
  final double aytCografya1; // maks 6

  final double diplomaGrade; // 50 - 100
  final bool isPreviousYearPlaced; // Kırık OBP

  double get totalTytNet => tytTurkce + tytMatematik + tytSosyal + tytFen;

  SimulationInput copyWith({
    SimulationField? field,
    double? tytTurkce,
    double? tytMatematik,
    double? tytSosyal,
    double? tytFen,
    double? aytMatematik,
    double? aytFizik,
    double? aytKimya,
    double? aytBiyoloji,
    double? aytEdebiyat,
    double? aytTarih1,
    double? aytCografya1,
    double? diplomaGrade,
    bool? isPreviousYearPlaced,
  }) {
    return SimulationInput(
      field: field ?? this.field,
      tytTurkce: tytTurkce ?? this.tytTurkce,
      tytMatematik: tytMatematik ?? this.tytMatematik,
      tytSosyal: tytSosyal ?? this.tytSosyal,
      tytFen: tytFen ?? this.tytFen,
      aytMatematik: aytMatematik ?? this.aytMatematik,
      aytFizik: aytFizik ?? this.aytFizik,
      aytKimya: aytKimya ?? this.aytKimya,
      aytBiyoloji: aytBiyoloji ?? this.aytBiyoloji,
      aytEdebiyat: aytEdebiyat ?? this.aytEdebiyat,
      aytTarih1: aytTarih1 ?? this.aytTarih1,
      aytCografya1: aytCografya1 ?? this.aytCografya1,
      diplomaGrade: diplomaGrade ?? this.diplomaGrade,
      isPreviousYearPlaced: isPreviousYearPlaced ?? this.isPreviousYearPlaced,
    );
  }
}

/// Simülasyon hesaplama sonucu
class SimulationResult {
  const SimulationResult({
    required this.field,
    required this.tytScore,
    required this.fieldRawScore,
    required this.obpScore,
    required this.obpContribution,
    required this.placementScore,
    required this.disclaimer,
    required this.curriculumYear,
  });

  final SimulationField field;
  final double tytScore; // TYT Ham Puanı (100 - 500)
  final double fieldRawScore; // İlgili Alan Ham Puanı (100 - 500)
  final double obpScore; // 250 - 500 arası OBP
  final double obpContribution; // Yerleştirmeye eklenen puan (30 - 60 arası)
  final double placementScore; // Yerleştirme Puanı (Ham + OBP)
  final String disclaimer; // Yasal sınırlılık uyarısı
  final int curriculumYear; // Temsili kılavuz yılı (örn. 2026)
}
