enum HandoverMode { physical, digital }

enum DemoLockState { unconfirmed, acknowledged, uncertain, rejected }

class HandoverPrerequisites {
  const HandoverPrerequisites(
      {required this.bookingConfirmed,
      required this.pickupWindow,
      required this.driverAuthorized,
      required this.vehicleReady,
      this.compatible = false});
  final bool bookingConfirmed;
  final bool pickupWindow;
  final bool driverAuthorized;
  final bool vehicleReady;
  final bool compatible;
}

/// Fail-closed demonstration only. No hardware command or real trip state.
class DemoHandover {
  DemoHandover(this.mode);
  final HandoverMode mode;
  bool _preflightPassed = false;
  DemoLockState _lock = DemoLockState.unconfirmed;
  bool get preflightPassed => _preflightPassed;
  DemoLockState get lock => _lock;
  bool _completed = false;
  bool get completed => _completed;
  void invalidateCompletion() => _completed = false;

  void preflight(HandoverPrerequisites prerequisites) {
    _preflightPassed = false;
    _lock = DemoLockState.unconfirmed;
    _completed = false;
    if (!prerequisites.bookingConfirmed ||
        !prerequisites.pickupWindow ||
        !prerequisites.driverAuthorized ||
        !prerequisites.vehicleReady) {
      throw StateError(
          'Rezervasyon, teslim zamanı, sürücü ve araç koşulları gerekli.');
    }
    if (mode == HandoverMode.digital && !prerequisites.compatible) {
      throw StateError('Dijital demo için temsili donanım uyumluluğu gerekli.');
    }
    _preflightPassed = true;
  }

  void acknowledgeDemoUnlock({required bool accepted}) {
    if (!_preflightPassed || mode != HandoverMode.digital || completed) {
      throw StateError('Dijital ön kontrol geçmeden örnek onay alınamaz.');
    }
    _lock = accepted ? DemoLockState.acknowledged : DemoLockState.rejected;
  }

  void connectionLost() {
    _preflightPassed = false;
    _lock = DemoLockState.uncertain;
    _completed = false;
  }

  void invalidate() {
    _preflightPassed = false;
    _lock = DemoLockState.unconfirmed;
    _completed = false;
  }

  void finish(
      {required bool bookingStillConfirmed,
      required bool inspectionComplete,
      required bool readingsRecorded,
      required bool partiesVerified,
      required bool mutualAcceptance}) {
    if (completed) throw StateError('Bu demo teslim zaten tamamlandı.');
    if (!bookingStillConfirmed ||
        !_preflightPassed ||
        !inspectionComplete ||
        !readingsRecorded ||
        !mutualAcceptance) {
      throw StateError(
          'Ön kontrol, inceleme, sayaç/enerji ve karşılıklı onay eksik.');
    }
    if (mode == HandoverMode.physical && !partiesVerified) {
      throw StateError(
          'Fiziksel teslimde iki tarafın temsili doğrulaması gerekli.');
    }
    if (mode == HandoverMode.digital && _lock != DemoLockState.acknowledged) {
      throw StateError('Kilit onayı yok veya belirsiz; demo tamamlanamaz.');
    }
    _completed = true;
  }
}
