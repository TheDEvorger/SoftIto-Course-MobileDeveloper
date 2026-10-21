import '../../discovery/domain/vehicle.dart';

class PriceQuote {
  const PriceQuote(
      {required this.token,
      required this.rateMinor,
      required this.totalMinor,
      required this.currency,
      required this.expiresAt});
  final String token, currency;
  final int rateMinor, totalMinor;
  final DateTime expiresAt;
  bool get expired => !expiresAt.isAfter(DateTime.now());
  String get totalLabel => moneyLabel(totalMinor, currency);
  String get rateLabel => moneyLabel(rateMinor, currency);
  factory PriceQuote.fromJson(Map<String, dynamic> json) => PriceQuote(
      token: json['token'] as String,
      rateMinor: json['rate_minor'] as int,
      totalMinor: json['total_minor'] as int,
      currency: json['currency'] as String,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(
          (json['expires_at'] as int) * 1000));
}
