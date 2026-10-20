class DemoVehicle {
  const DemoVehicle(
      this.name, this.category, this.pricePerDay, this.distanceKm, this.isFleet,
      {required this.id,
      required this.seats,
      required this.energy,
      required this.description});
  final String id;
  final String name;
  final String category;
  final int pricePerDay;
  final double distanceKm;
  final bool isFleet;
  final int seats;
  final String energy;
  final String description;
  String get providerLabel =>
      isFleet ? 'Örnek filo' : 'Örnek bireysel araç sahibi';
}

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

DemoVehicle? findDemoVehicle(String id) {
  for (final vehicle in demoVehicles) {
    if (vehicle.id == id) return vehicle;
  }
  return null;
}
