import 'package:flutter/material.dart';

class Era {
  const Era(this.name, this.tagline, this.primary, this.secondary, this.accent, this.ranks);
  final String name;
  final String tagline;
  final Color primary;
  final Color secondary;
  final Color accent;
  final List<String> ranks;
}

const eras = <Era>[
  Era('Uyanış', 'Bir kıvılcımla başlar.', Color(0xFF246F72), Color(0xFFB6E9DE), Color(0xFFFFC66E), ['Kıvılcım', 'Çırak', 'Yolcu', 'İzci']),
  Era('Nizam', 'Söz mühürlenir, düzen kurulur.', Color(0xFF436FA6), Color(0xFFC5E3F6), Color(0xFFF6BD70), ['Kâtip', 'Tertipçi', 'Mühürdar', 'Ahit Bekçisi']),
  Era('Sefer', 'Yol uzundur; çizme sağlam.', Color(0xFF148572), Color(0xFFB7F3DD), Color(0xFFEE9D59), ['Avcı', 'Maceracı', 'Öncü', 'Sancaktar']),
  Era('Kudret', 'Kalkanın asıl gücü istikrardır.', Color(0xFF6860AE), Color(0xFFD7D2FA), Color(0xFFFFCB68), ['Silahşor', 'Muhafız', 'Süvari', 'Serdar']),
  Era('Beylik', 'Bir çentikten bir kaleye.', Color(0xFFA0526F), Color(0xFFF8CCDB), Color(0xFFE6A951), ['Toprak Sahibi', 'Toprak Beyi', 'Derebeyi', 'Beylerbeyi']),
  Era('Taht', 'Kral öldü! Yaşasın yeni kral!', Color(0xFF3158AE), Color(0xFFCEDEFF), Color(0xFFF5BF59), ['Divan Reisi', 'Veliaht', 'Kral Naibi', 'Taç Giyen']),
];

Era eraForLevel(int level) => eras[((level - 1).clamp(0, 23)) ~/ 4];
String rankForLevel(int level) => eraForLevel(level).ranks[(level - 1).clamp(0, 23) % 4];
