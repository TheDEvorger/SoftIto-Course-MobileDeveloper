import 'rental_vehicle.dart';

class LocalReservation {
  const LocalReservation(
      {required this.id,
      required this.vehicleId,
      required this.start,
      required this.end,
      required this.totalMinor,
      required this.requestKey,
      this.cancelled = false});
  final String id, vehicleId, requestKey;
  final DateTime start, end;
  final int totalMinor;
  final bool cancelled;
  String get totalLabel => rentalMoney(totalMinor);
  LocalReservation cancel() => LocalReservation(
      id: id,
      vehicleId: vehicleId,
      start: start,
      end: end,
      totalMinor: totalMinor,
      requestKey: requestKey,
      cancelled: true);
  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicle': vehicleId,
        'start': rentalDateKey(start),
        'end': rentalDateKey(end),
        'total': totalMinor,
        'request': requestKey,
        'cancelled': cancelled
      };
  factory LocalReservation.fromJson(Map<String, dynamic> json) {
    final start = DateTime.parse(json['start'] as String);
    final end = DateTime.parse(json['end'] as String);
    final total = json['total'] as int;
    if (calendarDays(start, end) < 1 || total < 1) {
      throw const FormatException();
    }
    return LocalReservation(
        id: json['id'] as String,
        vehicleId: json['vehicle'] as String,
        start: start,
        end: end,
        totalMinor: total,
        requestKey: json['request'] as String,
        cancelled: json['cancelled'] as bool);
  }
}

class RentalQuote {
  const RentalQuote(
      {required this.vehicleId,
      required this.start,
      required this.end,
      required this.dailyMinor,
      required this.expiresAt});
  final String vehicleId;
  final DateTime start, end, expiresAt;
  final int dailyMinor;
  int get days => calendarDays(start, end);
  int get totalMinor => dailyMinor * days;
  String get totalLabel => rentalMoney(totalMinor);
}

class RentalFailure implements Exception {
  const RentalFailure(this.message);
  final String message;
  @override
  String toString() => message;
}
