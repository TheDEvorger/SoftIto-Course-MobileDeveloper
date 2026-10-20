/// Basit, paket gerektirmeyen Türkçe biçimlendirme yardımcıları.
abstract final class Formatters {
  static const List<String> _months = <String>[
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  static const List<String> _weekdays = <String>[
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar',
  ];

  static String _two(int v) => v.toString().padLeft(2, '0');

  /// 7 -> `S-007`
  static String queueNumber(int number) =>
      'S-${number.toString().padLeft(3, '0')}';

  /// `14:05`
  static String time(DateTime dt) => '${_two(dt.hour)}:${_two(dt.minute)}';

  /// `20 Ekim 2026, Salı`
  static String longDate(DateTime dt) =>
      '${dt.day} ${_months[dt.month - 1]} ${dt.year}, '
      '${_weekdays[dt.weekday - 1]}';

  /// `20 Eki · 14:05`
  static String shortDateTime(DateTime dt) =>
      '${dt.day} ${_months[dt.month - 1].substring(0, 3)} · ${time(dt)}';

  /// `Zeynep Arslan` -> `Zeynep A.` (listelerde mahremiyet için kısa ad)
  static String shortName(String fullName) {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.length < 2) return fullName.trim();
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }

  /// İki tarih arasındaki dakikayı okunur metne çevirir.
  static String duration(DateTime from, DateTime to) {
    final int minutes = to.difference(from).inMinutes;
    if (minutes < 1) return '1 dk içinde';
    if (minutes < 60) return '$minutes dk';
    return '${minutes ~/ 60} sa ${minutes % 60} dk';
  }

  /// Türkçe harflere duyarlı küçük harf dönüşümü (arama için).
  /// Dart'ın `toLowerCase()` metodu `İ` ve `I` harflerini Türkçeye göre
  /// dönüştürmediği için önce bu harfleri elle çeviriyoruz.
  static String searchKey(String text) =>
      text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase().trim();
}
