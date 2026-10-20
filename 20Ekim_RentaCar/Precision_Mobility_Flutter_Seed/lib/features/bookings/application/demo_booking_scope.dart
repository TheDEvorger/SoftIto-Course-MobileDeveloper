import 'package:flutter/material.dart';
import '../domain/booking_ledger.dart';

class DemoBookingController extends ChangeNotifier {
  final BookingLedger ledger = BookingLedger();
  DateTime Function() clock = DateTime.now;

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

  DemoBooking confirm(String id) {
    try {
      return ledger.confirm(id, clock());
    } finally {
      notifyListeners();
    }
  }

  DemoBooking cancel(String id) {
    try {
      return ledger.cancel(id, clock());
    } finally {
      notifyListeners();
    }
  }
}

class DemoBookingScope extends InheritedNotifier<DemoBookingController> {
  const DemoBookingScope(
      {super.key,
      required DemoBookingController controller,
      required super.child})
      : super(notifier: controller);

  static DemoBookingController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DemoBookingScope>()!.notifier!;
}
