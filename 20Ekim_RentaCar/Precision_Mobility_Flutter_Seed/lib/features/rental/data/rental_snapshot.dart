import 'dart:convert';
import '../domain/local_reservation.dart';

class RentalSnapshot {
  RentalSnapshot(
      {Set<String>? favorites,
      List<LocalReservation>? plans,
      this.theme = 'system',
      this.city = 'Tüm şehirler'})
      : favorites = favorites ?? {},
        plans = plans ?? [];
  final Set<String> favorites;
  final List<LocalReservation> plans;
  String theme, city;
  RentalSnapshot copy() => RentalSnapshot(
      favorites: {...favorites}, plans: [...plans], theme: theme, city: city);
  String encode() => jsonEncode({
        'version': 1,
        'favorites': favorites.toList(),
        'plans': plans.map((r) => r.toJson()).toList(),
        'theme': theme,
        'city': city
      });
  factory RentalSnapshot.decode(String raw) {
    final data = jsonDecode(raw) as Map<String, dynamic>;
    if (data['version'] != 1 ||
        !['system', 'light', 'dark'].contains(data['theme']) ||
        !['Tüm şehirler', 'İstanbul', 'Ankara', 'İzmir']
            .contains(data['city'])) {
      throw const FormatException();
    }
    return RentalSnapshot(
        favorites: (data['favorites'] as List).cast<String>().toSet(),
        plans: (data['plans'] as List)
            .map((r) => LocalReservation.fromJson(r as Map<String, dynamic>))
            .toList(),
        theme: data['theme'] as String,
        city: data['city'] as String);
  }
}
