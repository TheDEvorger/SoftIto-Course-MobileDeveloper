import 'package:sqflite/sqflite.dart';

import '../../core/database/schema.dart';
import '../models/curriculum.dart';

class CurriculumRepository {
  CurriculumRepository(this.db);
  final Database db;

  Future<List<Subject>> getSubjects(String stage) async {
    final maps = await db.query(
      GardenDatabaseSchema.tableSubjects,
      where: 'stage = ?',
      whereArgs: [stage],
      orderBy: 'order_index ASC',
    );
    return maps.map(Subject.fromMap).toList();
  }

  Future<List<Topic>> getTopics(String subjectId) async {
    final maps = await db.query(
      GardenDatabaseSchema.tableTopics,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'order_index ASC',
    );
    return maps.map(Topic.fromMap).toList();
  }

  Future<TopicProgress> getTopicProgress(String topicId) async {
    final maps = await db.query(
      GardenDatabaseSchema.tableTopicProgress,
      where: 'topic_id = ?',
      whereArgs: [topicId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return TopicProgress.fromMap(maps.first);
    }
    return TopicProgress(topicId: topicId);
  }

  Future<void> updateTopicProgress(TopicProgress progress) async {
    await db.insert(
      GardenDatabaseSchema.tableTopicProgress,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, TopicProgress>> getAllProgressForSubject(
      String subjectId) async {
    final topics = await getTopics(subjectId);
    if (topics.isEmpty) return {};

    final topicIds = topics.map((t) => t.id).toList();
    final placeholders = List.filled(topicIds.length, '?').join(',');

    final maps = await db.query(
      GardenDatabaseSchema.tableTopicProgress,
      where: 'topic_id IN ($placeholders)',
      whereArgs: topicIds,
    );

    final result = <String, TopicProgress>{};
    for (final map in maps) {
      final p = TopicProgress.fromMap(map);
      result[p.topicId] = p;
    }
    return result;
  }

  Future<Map<String, int>> getStageSummary(String stage) async {
    final subjects = await getSubjects(stage);
    if (subjects.isEmpty) {
      return {'totalTopics': 0, 'completedTopics': 0, 'inProgressTopics': 0};
    }

    final subjectIds = subjects.map((s) => s.id).toList();
    final placeholders = List.filled(subjectIds.length, '?').join(',');

    final topics = await db.query(
      GardenDatabaseSchema.tableTopics,
      where: 'subject_id IN ($placeholders)',
      whereArgs: subjectIds,
    );

    if (topics.isEmpty) {
      return {'totalTopics': 0, 'completedTopics': 0, 'inProgressTopics': 0};
    }

    final topicIds = topics.map((t) => t['id'] as String).toList();
    final topicPlaceholders = List.filled(topicIds.length, '?').join(',');

    final progressMaps = await db.query(
      GardenDatabaseSchema.tableTopicProgress,
      where: 'topic_id IN ($topicPlaceholders)',
      whereArgs: topicIds,
    );

    var completed = 0;
    var inProgress = 0;
    for (final m in progressMaps) {
      final status = m['status'] as String;
      if (status == TopicStatus.completed.name) {
        completed++;
      } else if (status == TopicStatus.inProgress.name) {
        inProgress++;
      }
    }

    return {
      'totalTopics': topics.length,
      'completedTopics': completed,
      'inProgressTopics': inProgress,
    };
  }

  Future<Map<String, Map<String, int>>> getSubjectStatsForStage(
      String stage) async {
    final subjects = await getSubjects(stage);
    if (subjects.isEmpty) return {};

    final subjectIds = subjects.map((s) => s.id).toList();
    final placeholders = List.filled(subjectIds.length, '?').join(',');

    final topics = await db.query(
      GardenDatabaseSchema.tableTopics,
      where: 'subject_id IN ($placeholders)',
      whereArgs: subjectIds,
    );

    final progressMaps =
        await db.query(GardenDatabaseSchema.tableTopicProgress);
    final completedTopicIds = progressMaps
        .where((m) => m['status'] == TopicStatus.completed.name)
        .map((m) => m['topic_id'] as String)
        .toSet();

    final result = <String, Map<String, int>>{};
    for (final s in subjects) {
      result[s.id] = {'total': 0, 'completed': 0};
    }
    for (final t in topics) {
      final sId = t['subject_id'] as String;
      final tId = t['id'] as String;
      if (result.containsKey(sId)) {
        result[sId]!['total'] = (result[sId]!['total'] ?? 0) + 1;
        if (completedTopicIds.contains(tId)) {
          result[sId]!['completed'] = (result[sId]!['completed'] ?? 0) + 1;
        }
      }
    }
    return result;
  }

  Future<void> seedInitialCurriculumIfEmpty() async {
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
          'SELECT COUNT(*) FROM ${GardenDatabaseSchema.tableSubjects}'),
    );
    if ((count ?? 0) > 0) return;

    await db.transaction((txn) async {
      final batch = txn.batch();

      // TYT Dersleri
      const tytSubjects = [
        Subject(
            id: 'tyt_turkce',
            stage: 'TYT',
            name: 'Türkçe',
            orderIndex: 1,
            questionCount: 40),
        Subject(
            id: 'tyt_mat',
            stage: 'TYT',
            name: 'Temel Matematik',
            orderIndex: 2,
            questionCount: 40),
        Subject(
            id: 'tyt_sosyal',
            stage: 'TYT',
            name: 'Sosyal Bilimler',
            orderIndex: 3,
            questionCount: 20),
        Subject(
            id: 'tyt_fen',
            stage: 'TYT',
            name: 'Fen Bilimleri',
            orderIndex: 4,
            questionCount: 20),
      ];

      for (final s in tytSubjects) {
        batch.insert(GardenDatabaseSchema.tableSubjects, s.toMap());
      }

      // AYT Dersleri
      const aytSubjects = [
        Subject(
            id: 'ayt_mat',
            stage: 'AYT',
            name: 'Matematik & Geometri',
            orderIndex: 1,
            questionCount: 40),
        Subject(
            id: 'ayt_fizik',
            stage: 'AYT',
            name: 'Fizik',
            orderIndex: 2,
            questionCount: 14),
        Subject(
            id: 'ayt_kimya',
            stage: 'AYT',
            name: 'Kimya',
            orderIndex: 3,
            questionCount: 13),
        Subject(
            id: 'ayt_biyo',
            stage: 'AYT',
            name: 'Biyoloji',
            orderIndex: 4,
            questionCount: 13),
        Subject(
            id: 'ayt_edebiyat',
            stage: 'AYT',
            name: 'Türk Dili ve Edebiyatı',
            orderIndex: 5,
            questionCount: 24),
        Subject(
            id: 'ayt_tarih1',
            stage: 'AYT',
            name: 'Tarih-1',
            orderIndex: 6,
            questionCount: 10),
        Subject(
            id: 'ayt_cografya1',
            stage: 'AYT',
            name: 'Coğrafya-1',
            orderIndex: 7,
            questionCount: 6),
      ];

      for (final s in aytSubjects) {
        batch.insert(GardenDatabaseSchema.tableSubjects, s.toMap());
      }

      // Konu listesi ekleme fonksiyonu
      void addTopics(String subjectId, List<String> topicNames) {
        for (var i = 0; i < topicNames.length; i++) {
          final t = Topic(
            id: '${subjectId}_${i + 1}',
            subjectId: subjectId,
            name: topicNames[i],
            orderIndex: i + 1,
          );
          batch.insert(GardenDatabaseSchema.tableTopics, t.toMap());
        }
      }

      // TYT Konuları
      addTopics('tyt_turkce', const [
        'Sözcükte Anlam',
        'Cümlede Anlam',
        'Paragrafta Anlam',
        'Ses Bilgisi',
        'Yazım Kuralları',
        'Noktalama İşaretleri',
        'Sözcükte Yapı ve Ekler',
        'İsim, Sıfat, Zamir',
        'Zarf, Edat, Bağlaç, Ünlem',
        'Fiiller ve Fiilde Çatı',
        'Cümle Türleri ve Ögeleri',
        'Anlatım Bozuklukları',
      ]);

      addTopics('tyt_mat', const [
        'Temel Kavramlar',
        'Sayı Basamakları',
        'Bölme ve Bölünebilme',
        'EBOB - EKOK',
        'Rasyonel Sayılar',
        'Basit Eşitsizlikler',
        'Mutlak Değer',
        'Üslü İfadeler',
        'Köklü İfadeler',
        'Çarpanlara Ayırma',
        'Oran ve Orantı',
        'Denklem Çözme',
        'Problemler (Sayı, Kesir, Yaş, Yüzde, Hız)',
        'Kümeler ve Mantık',
        'Fonksiyonlar',
        'Polinomlar',
        'İkinci Dereceden Denklemler',
        'Permütasyon - Kombinasyon - Olasılık',
      ]);

      addTopics('tyt_sosyal', const [
        'Tarih Bilimine Giriş & İlk Çağ Uygarlıkları',
        'İslam Öncesi ve İslam Tarihi',
        'Osmanlı Devleti ve Kuruluş-Yükseliş',
        'Milli Mücadele ve Atatürk İnkılapları',
        'Doğa ve İnsan & Harita Bilgisi',
        'İklim Bilgisi & Türkiye İklimi',
        'Felsefenin Alanı ve Bilgi Felsefesi',
        'Ahlak ve Varlık Felsefesi',
        'Din Kültürü ve Ahlak Bilgisi Temel Konular',
      ]);

      addTopics('tyt_fen', const [
        'Fizik Bilimine Giriş & Madde ve Özellikleri',
        'Kuvvet ve Hareket (TYT)',
        'Isı ve Sıcaklık',
        'Elektrostatik ve Elektrik Devreleri',
        'Optik ve Dalgalar (TYT)',
        'Kimya Bilimi & Atom ve Periyodik Sistem',
        'Kimyasal Türler Arası Etkileşimler',
        'Maddenin Halleri & Asit, Baz, Tuz',
        'Canlıların Ortak Özellikleri ve Temel Bileşenler',
        'Hücre ve Organelleri & Hücre Bölünmeleri',
        'Kalıtım ve Canlılar Dünyası',
      ]);

      // AYT Konuları
      addTopics('ayt_mat', const [
        'Polinomlar ve Çarpanlara Ayırma (AYT)',
        'İkinci Dereceden Eşitsizlikler',
        'Parabol',
        'Trigonometri 1 & 2',
        'Logaritma',
        'Diziler',
        'Limit ve Süreklilik',
        'Türev ve Uygulamaları',
        'İntegral ve Uygulamaları',
        'Analitik Geometri & Çemberin Analitiği',
        'Uzay Geometri ve Katı Cisimler',
      ]);

      addTopics('ayt_fizik', const [
        'Vektörler ve Bağıl Hareket',
        'Newton’ın Hareket Yasaları (İleri)',
        'Bir Boyutta ve İki Boyutta Sabit İvmeli Hareket',
        'İş, Güç ve Enerji (AYT)',
        'İtme ve Çizgisel Momentum',
        'Tork, Denge ve Kütle Merkezi',
        'Elektriksel Kuvvet, Alan ve Potansiyel',
        'Manyetizma ve Elektromanyetik İndüksiyon',
        'Alternatif Akım ve Transformatörler',
        'Çembersel Hareket ve Basit Harmonik Hareket',
        'Dalga Mekaniği ve Modern Fizik',
      ]);

      addTopics('ayt_kimya', const [
        'Modern Atom Teorisi (AYT)',
        'Gazlar ve Gaz Yasaları',
        'Sıvı Çözeltiler ve Koligatif Özellikler',
        'Kimyasal Tepkimelerde Enerji (Entalpi)',
        'Kimyasal Tepkimelerde Hız',
        'Kimyasal Denge ve Dengeye Etki Eden Faktörler',
        'Sulu Çözelti Dengeleri (Asit-Baz Dengesi)',
        'Kimya ve Elektrik (Elektrokimya & Piller)',
        'Karbon Kimyasına Giriş',
        'Organik Kimya (Hidrokarbonlar ve Fonksiyonel Gruplar)',
      ]);

      addTopics('ayt_biyo', const [
        'Sinir Sistemi ve Duyu Organları',
        'Endokrin Sistem & Destek ve Hareket',
        'Sindirim, Dolaşım ve Bağışıklık Sistemi',
        'Solunum ve Boşaltım Sistemi',
        'Üreme Sistemi ve Embriyonik Gelişim',
        'Komünite ve Popülasyon Ekolojisi',
        'Nükleik Asitler ve Genden Proteine',
        'Fotosentez ve Kemosentez',
        'Hücresel Solunum',
        'Bitki Biyolojisi (Doku, Organ ve Üreme)',
        'Canlılar ve Çevre',
      ]);

      addTopics('ayt_edebiyat', const [
        'Şiir Bilgisi ve Edebi Sanatlar',
        'İslamiyet Öncesi ve Geçiş Dönemi Edebiyatı',
        'Halk Edebiyatı',
        'Divan Edebiyatı',
        'Tanzimat, Servetifünun ve Fecriati',
        'Milli Edebiyat Dönemi',
        'Cumhuriyet Dönemi Türk Edebiyatı',
        'Edebi Akımlar',
      ]);

      addTopics('ayt_tarih1', const [
        'Tarih ve Zaman & İlk Türk Devletleri',
        'İslam Medeniyetinin Doğuşu',
        'Türk-İslam Devletleri',
        'Klasik Çağda Osmanlı',
        '20. Yüzyıl Başlarında Osmanlı ve Dünya',
        'Milli Mücadele Dönemi (Ayrıntılı)',
        'Atatürkçülük ve Türk İnkılabı',
      ]);

      addTopics('ayt_cografya1', const [
        'Ekosistem ve Madde Döngüleri',
        'Nüfus Politikaları ve Şehirlerin Fonksiyonları',
        'Türkiye’de Tarım, Hayvancılık ve Madenler',
        'Bölgeler ve Ülkelerarası Ticaret',
        'Çevre ve Toplum Sorunları',
      ]);

      await batch.commit(noResult: true);
    });
  }
}
