import 'package:flutter/material.dart';

class BadgeDefinition {
  const BadgeDefinition(
      this.id, this.name, this.description, this.icon, this.era,
      {this.future = false});
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final int era;
  final bool future;
}

const badges = <BadgeDefinition>[
  BadgeDefinition(
      1, 'İlk Çentik', 'İlk vazifeni bitir.', Icons.auto_awesome, 0),
  BadgeDefinition(
      2, 'Mühür Daha Islak', 'İlk ahdini yaz.', Icons.history_edu, 0),
  BadgeDefinition(
      3, 'Yorganla Ateşkes', 'Beş vazife tamamla.', Icons.wb_sunny_outlined, 0),
  BadgeDefinition(4, 'Külden Kalkan', 'Aksadıktan sonra yeniden dön.',
      Icons.local_fire_department_outlined, 0),
  BadgeDefinition(5, 'Takvimin Efendisi', 'Yedi farklı gün ilerle.',
      Icons.calendar_month_outlined, 1),
  BadgeDefinition(
      6, 'Mühür Bozulmadı', 'İlk ahdini tamamla.', Icons.verified_outlined, 1),
  BadgeDefinition(
      7, 'Dakika Avcısı', 'On vazife tamamla.', Icons.timer_outlined, 1),
  BadgeDefinition(8, 'Kâtiplerin Korkusu', 'Dört hafta değerlendir.',
      Icons.menu_book_outlined, 1,
      future: true),
  BadgeDefinition(
      9, 'Pusula Şaşmaz', '14 gün boyunca %80 uyum.', Icons.explore_outlined, 2,
      future: true),
  BadgeDefinition(10, 'Üç Cepheli Sefer', 'Üç alışkanlığı aynı gün bitir.',
      Icons.flag_outlined, 2),
  BadgeDefinition(11, 'Ejderha da Neymiş!', 'Beş zor vazife tamamla.',
      Icons.bolt_outlined, 2),
  BadgeDefinition(
      12, 'Çizmeler Eskidi', 'Yüz vazife tamamla.', Icons.hiking_outlined, 2),
  BadgeDefinition(13, 'Demir İrade', 'Otuz güne yayılan istikrar.',
      Icons.shield_outlined, 3,
      future: true),
  BadgeDefinition(14, 'Kalkanı Yere Koyma', 'Üç defa geri dön.',
      Icons.security_outlined, 3),
  BadgeDefinition(15, 'Fırtına Yararı', 'Zor haftadan sonra toparlan.',
      Icons.thunderstorm_outlined, 3,
      future: true),
  BadgeDefinition(16, 'Nöbetin Ustası', 'Dinlenme ve çalışma dengesini kur.',
      Icons.nights_stay_outlined, 3,
      future: true),
  BadgeDefinition(17, 'Köyden Kaleye', 'Üç alışkanlığı bir ay sürdür.',
      Icons.castle_outlined, 4,
      future: true),
  BadgeDefinition(18, 'Haritaya Sığmayan', 'Üç alanda gelişim göster.',
      Icons.public_outlined, 4,
      future: true),
  BadgeDefinition(19, 'Ferman Üstüne Ferman', 'Beş ahit tamamla.',
      Icons.receipt_long_outlined, 4),
  BadgeDefinition(20, 'Seferin Mimarı', 'Otuz günlük seferi tamamla.',
      Icons.architecture_outlined, 4,
      future: true),
  BadgeDefinition(21, 'Mihmandarın Eli', 'İlk doğrulanmış topluluk yardımın.',
      Icons.volunteer_activism_outlined, 5,
      future: true),
  BadgeDefinition(22, 'Meydanın Dayanağı', 'On faydalı topluluk yardımın.',
      Icons.groups_outlined, 5,
      future: true),
  BadgeDefinition(23, 'Vakanüvis', 'On iki haftalık kronik yaz.',
      Icons.auto_stories_outlined, 5,
      future: true),
  BadgeDefinition(24, 'Tahtın Tozunu Aldık!', '90 günlük seferi bitir.',
      Icons.workspace_premium_outlined, 5,
      future: true),
];
