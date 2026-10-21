/// Keşif ve kiralama için örnek araç modeli.
/// Gerçek araç veya canlı telemetri içermez; temsili veriler taşır.
class DemoVehicle {
  const DemoVehicle(
      this.name, this.category, this.pricePerDay, this.distanceKm, this.isFleet,
      {required this.id,
      required this.seats,
      required this.energy,
      required this.description});

  /// Benzersiz araç kimliği (örn. 'executive-s')
  final String id;

  /// Araç model adı
  final String name;

  /// Araç kategorisi ve şanzıman türü (örn. 'Sedan • Otomatik')
  final String category;

  /// Günlük kiralama bedeli (TL cinsinden temsili)
  final int pricePerDay;

  /// Kullanıcıya olan temsili mesafe (km)
  final double distanceKm;

  /// Aracın bir kurumsal filoya mı yoksa bireysel araç sahibine mi ait olduğu
  final bool isFleet;

  /// Koltuk sayısı
  final int seats;

  /// Yakıt / enerji türü (örn. 'Benzin', 'Elektrik', 'Dizel')
  final String energy;

  /// Araç tanıtım açıklaması
  final String description;

  /// Sağlayıcı türü etiketi
  String get providerLabel =>
      isFleet ? 'Örnek filo' : 'Örnek bireysel araç sahibi';
}

/// Uygulama genelinde kullanılan statik örnek araç listesi
const demoVehicles = [
  DemoVehicle('Executive S', 'Sedan • Otomatik', 2450, 1.2, true,
      id: 'executive-s',
      seats: 5,
      energy: 'Benzin',
      description: 'Şehir ve uzun yol için örnek konfor sedanı.'),
  DemoVehicle('Urban E', 'Elektrikli • Otomatik', 1750, 2.4, false,
      id: 'urban-e',
      seats: 5,
      energy: 'Elektrik',
      description: 'Şehir içi kullanım için örnek elektrikli araç.'),
  DemoVehicle('Grand Tourer', 'SUV • Otomatik', 3150, 3.8, true,
      id: 'grand-tourer',
      seats: 7,
      energy: 'Dizel',
      description: 'Geniş iç hacimli örnek aile SUV aracı.'),
  DemoVehicle('City Compact', 'Hatchback • Otomatik', 1150, 4.1, false,
      id: 'city-compact',
      seats: 4,
      energy: 'Benzin',
      description: 'Kompakt boyutlu örnek şehir aracı.'),
];

/// Kimliğe (id) göre araç arar, bulunamazsa null döndürür.
DemoVehicle? findDemoVehicle(String id) {
  for (final vehicle in demoVehicles) {
    if (vehicle.id == id) return vehicle;
  }
  return null;
}
