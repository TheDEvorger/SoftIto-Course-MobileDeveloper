/// Teslimat yöntemi (Fiziksel anahtar teslimi veya Dijital akıllı kilit)
enum HandoverMode { physical, digital }

/// Dijital kilit onay durumları (fail-closed güvenlik prensibi ile)
enum DemoLockState { unconfirmed, acknowledged, uncertain, rejected }

/// Teslimatın başlayabilmesi için sağlanması zorunlu ön koşullar
class HandoverPrerequisites {
  const HandoverPrerequisites(
      {required this.bookingConfirmed,
      required this.pickupWindow,
      required this.driverAuthorized,
      required this.vehicleReady,
      this.compatible = false});

  /// Rezervasyonun aktif ve onaylı olup olmadığı
  final bool bookingConfirmed;

  /// Alış zaman aralığı (pickup window) içinde olunup olunmadığı
  final bool pickupWindow;

  /// Sürücünün kimlik ve ehliyet doğrulamasının geçerliliği
  final bool driverAuthorized;

  /// Aracın temizlik ve hazırlık durumunun uygunluğu
  final bool vehicleReady;

  /// Aracın dijital donanım ve telemetri uyumluluğu
  final bool compatible;
}

/// Temsili teslimat simülasyon mantığı (Fail-closed prensibi).
/// Donanım veya araç kilidine doğrudan komut göndermez; güvenlik doğrulamasını simüle eder.
class DemoHandover {
  DemoHandover(this.mode);

  /// Teslim yöntemi (fiziksel veya dijital)
  final HandoverMode mode;

  bool _preflightPassed = false;
  DemoLockState _lock = DemoLockState.unconfirmed;
  bool get preflightPassed => _preflightPassed;
  DemoLockState get lock => _lock;
  bool _completed = false;
  bool get completed => _completed;

  /// Koşullar değiştiğinde tamamlanma durumunu geçersiz kılar
  void invalidateCompletion() => _completed = false;

  /// Teslimat öncesi ön kontrol (Preflight) çalıştırır.
  /// Tüm zorunlu koşulların sağlanıp sağlanmadığını denetler.
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

  /// Dijital kilit yanıtını simüle eder (kabul veya ret).
  void acknowledgeDemoUnlock({required bool accepted}) {
    if (!_preflightPassed || mode != HandoverMode.digital || completed) {
      throw StateError('Dijital ön kontrol geçmeden örnek onay alınamaz.');
    }
    _lock = accepted ? DemoLockState.acknowledged : DemoLockState.rejected;
  }

  /// Bağlantı koptuğunda durumu 'uncertain' yapar ve tamamlanmayı engeller (fail-closed).
  void connectionLost() {
    _preflightPassed = false;
    _lock = DemoLockState.uncertain;
    _completed = false;
  }

  /// Durumu sıfırlar.
  void invalidate() {
    _preflightPassed = false;
    _lock = DemoLockState.unconfirmed;
    _completed = false;
  }

  /// Teslimatı nihai olarak tamamlar; inceleme, sayaç okumaları ve onayların tam olduğunu doğrular.
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
