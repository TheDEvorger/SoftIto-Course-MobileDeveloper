import 'package:flutter/material.dart';
import '../domain/booking_ledger.dart';

/// Rezervasyon durumu ve işlemlerini yöneten ChangeNotifier sınıfı.
/// UI bileşenlerini değişikliklerden haberdar eder (notifyListeners).
class DemoBookingController extends ChangeNotifier {
  /// Rezervasyon kayıt defteri
  final BookingLedger ledger = BookingLedger();

  /// Test edilebilirlik için saat fonksiyonu (varsayılan: DateTime.now)
  DateTime Function() clock = DateTime.now;

  /// Belirtilen gün sayısı (1-7 gün) için teklif üretir.
  DemoBooking quote(
      {required String vehicleId,
      required String vehicleName,
      required int dailyRate,
      required int days}) {
    if (days < 1 || days > 7) throw ArgumentError('Demo süre 1–7 gün olmalı.');
    final now = clock();
    final start = DateTime(now.year, now.month, now.day + 1, 10);
    final result = ledger.quote(
        vehicleId: vehicleId,
        vehicleName: vehicleName,
        dailyRate: dailyRate,
        start: start,
        end: start.add(Duration(days: days)),
        now: now);
    notifyListeners();
    return result;
  }

  /// Belirtilen teklifi onaylar ve dinleyicileri uyarır.
  DemoBooking confirm(String id) {
    try {
      return ledger.confirm(id, clock());
    } finally {
      notifyListeners();
    }
  }

  /// Belirtilen rezervasyonu iptal eder ve dinleyicileri uyarır.
  DemoBooking cancel(String id) {
    try {
      return ledger.cancel(id, clock());
    } finally {
      notifyListeners();
    }
  }
}

/// Widget ağacında DemoBookingController'a erişim sağlayan InheritedNotifier sınıfı.
class DemoBookingScope extends InheritedNotifier<DemoBookingController> {
  const DemoBookingScope(
      {super.key,
      required DemoBookingController controller,
      required super.child})
      : super(notifier: controller);

  /// Alt widget'lardan controller'a güvenli erişim metodu
  static DemoBookingController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DemoBookingScope>()!.notifier!;
}
