class RentalVehicle {
  const RentalVehicle(
      {required this.id,
      required this.name,
      required this.category,
      required this.city,
      required this.pickup,
      required this.energy,
      required this.dailyMinor,
      required this.image,
      required this.description,
      this.seats = 5,
      this.bags = 2,
      this.gearbox = 'Otomatik',
      this.fleet = true});
  final String id,
      name,
      category,
      city,
      pickup,
      energy,
      image,
      description,
      gearbox;
  final int dailyMinor, seats, bags;
  final bool fleet;
  String get dailyLabel => rentalMoney(dailyMinor);
}

String rentalMoney(int minor) {
  final whole = (minor ~/ 100)
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  return '$whole,${(minor % 100).toString().padLeft(2, '0')} ₺';
}

int calendarDays(DateTime start, DateTime end) =>
    DateTime.utc(end.year, end.month, end.day)
        .difference(DateTime.utc(start.year, start.month, start.day))
        .inDays;
String rentalDateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
