import '../../discovery/domain/vehicle.dart';

class Reservation {
  const Reservation(
      {required this.id,
      required this.vehicleId,
      required this.vehicleName,
      required this.start,
      required this.end,
      required this.totalMinor,
      required this.status,
      required this.currency});
  final String id, vehicleId, vehicleName, status, currency;
  final DateTime start, end;
  final int totalMinor;
  bool get cancelled => status == 'cancelled';
  String get totalLabel => moneyLabel(totalMinor, currency);
  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
      id: json['id'] as String,
      vehicleId: json['vehicle_id'] as String,
      vehicleName: json['vehicle_name'] as String,
      start: DateTime.parse(json['starts_on'] as String),
      end: DateTime.parse(json['ends_on'] as String),
      totalMinor: json['total_minor'] as int,
      status: json['status'] as String,
      currency: json['currency'] as String);
}
