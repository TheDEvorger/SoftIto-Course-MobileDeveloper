class Vehicle {
  const Vehicle(
      {required this.id,
      required this.name,
      required this.category,
      required this.energy,
      required this.seats,
      required this.rateMinor,
      required this.ownership,
      required this.description,
      this.photoUrl = '',
      this.published = true,
      this.example = false,
      this.artwork = '',
      this.status = 'active',
      this.currency = 'TRY'});
  final String id,
      name,
      category,
      energy,
      ownership,
      description,
      photoUrl,
      status,
      currency;
  final int seats, rateMinor;
  final bool published, example;
  final String artwork;
  bool get isFleet => ownership == 'fleet';
  bool get inMaintenance => status == 'maintenance';
  String get statusLabel => inMaintenance
      ? 'Bakımda'
      : published
          ? 'Yayında'
          : 'Yayında değil';
  String get rateLabel => moneyLabel(rateMinor, currency);
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      energy: json['energy'] as String,
      seats: json['seats'] as int,
      rateMinor: json['rate_minor'] as int,
      ownership: json['ownership'] as String,
      description: json['description'] as String,
      photoUrl: json['photo_url'] as String? ?? '',
      published: json['published'] != 0 && json['published'] != false,
      example: json['example'] == true,
      artwork: json['artwork'] as String? ?? '',
      status: json['status'] as String,
      currency: json['currency'] as String);
}

String moneyLabel(int minor, String currency) =>
    '${minor ~/ 100},${(minor % 100).toString().padLeft(2, '0')} $currency';
String dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
int rentalDays(DateTime start, DateTime end) =>
    DateTime.utc(end.year, end.month, end.day)
        .difference(DateTime.utc(start.year, start.month, start.day))
        .inDays;
