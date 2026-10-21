import '../domain/rental_vehicle.dart';

// Bundled representative collection. No live supplier data or remote images.
const rentalCatalog = <RentalVehicle>[
  RentalVehicle(
      id: 'clio',
      name: 'Renault Clio',
      category: 'Ekonomik',
      city: 'İstanbul',
      pickup: 'Kadıköy',
      energy: 'Benzin',
      dailyMinor: 145000,
      image: 'compact',
      description:
          'Şehir içindeki kısa rotalar için pratik bir seçenek. Kompakt sınıf, otomatik vites ve kolay park.'),
  RentalVehicle(
      id: 'bmw-320',
      name: 'BMW 320i',
      category: 'Premium',
      city: 'İstanbul',
      pickup: 'Beşiktaş',
      energy: 'Benzin',
      dailyMinor: 385000,
      image: 'touring',
      fleet: false,
      description:
          'İş planlarından hafta sonu kaçamaklarına. Geniş kabin ve konfor odaklı premium sınıf.'),
  RentalVehicle(
      id: 'tesla-3',
      name: 'Tesla Model 3',
      category: 'Elektrikli',
      city: 'İstanbul',
      pickup: 'Ataşehir',
      energy: 'Elektrik',
      dailyMinor: 295000,
      image: 'electric',
      bags: 3,
      description:
          'Sessiz bir sürüş, ferah bir kabin. Elektrikli otomobil deneyimini rotanıza ekleyin.'),
  RentalVehicle(
      id: 'peugeot-3008',
      name: 'Peugeot 3008',
      category: 'SUV',
      city: 'İzmir',
      pickup: 'Bornova',
      energy: 'Hibrit',
      dailyMinor: 265000,
      image: 'suv',
      bags: 3,
      description:
          'Aile planlarına ve uzun rotalara yer açın. Yüksek oturma konumu ve geniş bagaj.'),
  RentalVehicle(
      id: 'corolla',
      name: 'Toyota Corolla',
      category: 'Konfor',
      city: 'Ankara',
      pickup: 'Çankaya',
      energy: 'Hibrit',
      dailyMinor: 195000,
      image: 'electric',
      bags: 3,
      description:
          'Günlük planlarda rahat bir yol arkadaşı. Sedan kabin ve konforlu yolculuk alanı.'),
  RentalVehicle(
      id: 'mercedes-c',
      name: 'Mercedes-Benz C200',
      category: 'Premium',
      city: 'İzmir',
      pickup: 'Alsancak',
      energy: 'Benzin',
      dailyMinor: 425000,
      image: 'touring',
      fleet: false,
      description:
          'Özenli detaylar ve sakin bir sürüş. Özel günler ve uzun yol planları için premium sınıf.'),
  RentalVehicle(
      id: 'golf',
      name: 'Volkswagen Golf',
      category: 'Konfor',
      city: 'İstanbul',
      pickup: 'Bakırköy',
      energy: 'Benzin',
      dailyMinor: 225000,
      image: 'compact',
      description:
          'Şehir ve uzun yol arasında dengeli bir seçenek. Kompakt gövde, kullanışlı iç mekân.'),
  RentalVehicle(
      id: 'i20',
      name: 'Hyundai i20',
      category: 'Ekonomik',
      city: 'Ankara',
      pickup: 'Kızılay',
      energy: 'Benzin',
      dailyMinor: 135000,
      image: 'compact',
      description:
          'Gündelik işlerinize ve kısa kaçamaklara uyum sağlayan ekonomik sınıf otomobil.'),
  RentalVehicle(
      id: 'tucson',
      name: 'Hyundai Tucson',
      category: 'SUV',
      city: 'İstanbul',
      pickup: 'Üsküdar',
      energy: 'Hibrit',
      dailyMinor: 285000,
      image: 'suv',
      bags: 3,
      description:
          'Daha geniş bir yolculuk alanı. Hafta sonu valizleri ve aile rotaları için SUV sınıfı.'),
];
