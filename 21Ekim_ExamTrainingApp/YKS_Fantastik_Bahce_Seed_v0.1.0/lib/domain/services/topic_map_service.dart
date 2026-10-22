import '../models/curriculum.dart';
import '../models/topic_relation.dart';
import '../repositories/curriculum_repository.dart';

/// MEB müfredatına dayalı doğrulanmış konu ilişkileri ve aralıklı tekrar servisi.
class TopicMapService {
  TopicMapService(this.curriculumRepository);

  final CurriculumRepository curriculumRepository;

  /// Doğrulanmış MEB Pedagojik Önkoşul Veri Seti (Önkoşul -> Hedef Konu)
  static const Map<String, List<String>> prerequisitesByTopicId = {
    // TYT Matematik Zinciri
    'tyt_mat_2': ['tyt_mat_1'], // Sayı Basamakları <- Temel Kavramlar
    'tyt_mat_3': ['tyt_mat_1'], // Bölme Bölünebilme <- Temel Kavramlar
    'tyt_mat_4': ['tyt_mat_3'], // EBOB EKOK <- Bölme Bölünebilme
    'tyt_mat_5': ['tyt_mat_1'], // Rasyonel Sayılar <- Temel Kavramlar
    'tyt_mat_6': ['tyt_mat_5'], // Basit Eşitsizlikler <- Rasyonel Sayılar
    'tyt_mat_7': ['tyt_mat_6'], // Mutlak Değer <- Basit Eşitsizlikler
    'tyt_mat_8': ['tyt_mat_1'], // Üslü İfadeler <- Temel Kavramlar
    'tyt_mat_9': ['tyt_mat_8'], // Köklü İfadeler <- Üslü İfadeler
    'tyt_mat_10': ['tyt_mat_8'], // Çarpanlara Ayırma <- Üslü İfadeler
    'tyt_mat_11': ['tyt_mat_5'], // Oran Orantı <- Rasyonel Sayılar
    'tyt_mat_12': ['tyt_mat_10'], // Denklem Çözme <- Çarpanlara Ayırma
    'tyt_mat_13': [
      'tyt_mat_11',
      'tyt_mat_12'
    ], // Problemler <- Oran Orantı + Denklem
    'tyt_mat_15': ['tyt_mat_12'], // Fonksiyonlar <- Denklem Çözme
    'tyt_mat_16': [
      'tyt_mat_15',
      'tyt_mat_10'
    ], // Polinomlar <- Fonksiyonlar + Çarpanlara Ayırma
    'tyt_mat_17': [
      'tyt_mat_10',
      'tyt_mat_12'
    ], // İkinci Dereceden Denklemler <- Çarpanlara Ayırma + Denklem

    // AYT Matematik Zinciri
    'ayt_mat_1': [
      'tyt_mat_16'
    ], // Polinomlar ve Çarpanlara Ayırma (AYT) <- TYT Polinomlar
    'ayt_mat_2': [
      'tyt_mat_17',
      'tyt_mat_6'
    ], // İkinci Dereceden Eşitsizlikler <- İkinci Dereceden Denklemler + Eşitsizlikler
    'ayt_mat_3': ['tyt_mat_17'], // Parabol <- İkinci Dereceden Denklemler
    'ayt_mat_4': ['tyt_mat_15'], // Trigonometri 1 & 2 <- Fonksiyonlar
    'ayt_mat_5': [
      'tyt_mat_8',
      'tyt_mat_15'
    ], // Logaritma <- Üslü İfadeler + Fonksiyonlar
    'ayt_mat_6': ['ayt_mat_5'], // Diziler <- Logaritma / Fonksiyonlar
    'ayt_mat_7': [
      'ayt_mat_6',
      'tyt_mat_15'
    ], // Limit ve Süreklilik <- Diziler + Fonksiyonlar
    'ayt_mat_8': ['ayt_mat_7'], // Türev ve Uygulamaları <- Limit ve Süreklilik
    'ayt_mat_9': [
      'ayt_mat_8'
    ], // İntegral ve Uygulamaları <- Türev ve Uygulamaları

    // Fizik Zinciri
    'ayt_fizik_1': [
      'tyt_fen_2'
    ], // Vektörler ve Bağıl Hareket <- Kuvvet ve Hareket (TYT)
    'ayt_fizik_2': ['ayt_fizik_1'], // Newton'ın Hareket Yasaları <- Vektörler
    'ayt_fizik_3': ['ayt_fizik_2'], // Sabit İvmeli Hareket <- Newton Yasaları
    'ayt_fizik_4': ['ayt_fizik_3'], // İş, Güç ve Enerji (AYT) <- İvmeli Hareket
    'ayt_fizik_5': ['ayt_fizik_4'], // İtme ve Çizgisel Momentum <- Enerji
    'ayt_fizik_6': ['ayt_fizik_1'], // Tork ve Denge <- Vektörler
    'ayt_fizik_7': [
      'tyt_fen_4'
    ], // Elektriksel Kuvvet & Alan <- Elektrostatik (TYT)
    'ayt_fizik_8': ['ayt_fizik_7'], // Manyetizma <- Elektriksel Alan
    'ayt_fizik_9': ['ayt_fizik_8'], // Alternatif Akım <- Manyetizma
    'ayt_fizik_10': [
      'ayt_fizik_3'
    ], // Çembersel & Harmonik Hareket <- İvmeli Hareket

    // Kimya Zinciri
    'ayt_kimya_1': [
      'tyt_fen_6'
    ], // Modern Atom Teorisi <- Atom ve Periyodik Sistem (TYT)
    'ayt_kimya_2': [
      'ayt_kimya_1',
      'tyt_fen_8'
    ], // Gazlar <- Atom Teorisi + Maddenin Halleri
    'ayt_kimya_3': ['ayt_kimya_2'], // Sıvı Çözeltiler <- Gazlar
    'ayt_kimya_4': [
      'ayt_kimya_3'
    ], // Kimyasal Enerji (Entalpi) <- Sıvı Çözeltiler
    'ayt_kimya_5': ['ayt_kimya_4'], // Kimyasal Hız <- Kimyasal Enerji
    'ayt_kimya_6': ['ayt_kimya_5'], // Kimyasal Denge <- Kimyasal Hız
    'ayt_kimya_7': ['ayt_kimya_6'], // Asit-Baz Dengesi <- Kimyasal Denge
    'ayt_kimya_8': ['ayt_kimya_7'], // Elektrokimya & Piller <- Asit-Baz Dengesi

    // Biyoloji Zinciri
    'ayt_biyo_7': [
      'tyt_fen_9',
      'tyt_fen_10'
    ], // Nükleik Asitler <- Canlıların Bileşenleri + Hücre
    'ayt_biyo_8': ['ayt_biyo_7'], // Fotosentez & Kemosentez <- Nükleik Asitler
    'ayt_biyo_9': ['ayt_biyo_8'], // Hücresel Solunum <- Fotosentez
    'ayt_biyo_1': ['tyt_fen_10'], // Sinir Sistemi <- Hücre ve Organelleri
  };

  /// Belirli bir branş/alan zinciri için graf düğümlerini oluşturur
  Future<List<TopicNodeInfo>> getTopicNodesForBranch({
    required String branchKey, // 'matematik', 'fizik', 'kimya', 'biyoloji'
    DateTime? simulatedNow,
  }) async {
    final now = simulatedNow ?? DateTime.now();

    List<String> subjectIds;
    switch (branchKey) {
      case 'fizik':
        subjectIds = ['tyt_fen', 'ayt_fizik'];
        break;
      case 'kimya':
        subjectIds = ['tyt_fen', 'ayt_kimya'];
        break;
      case 'biyoloji':
        subjectIds = ['tyt_fen', 'ayt_biyo'];
        break;
      case 'matematik':
      default:
        subjectIds = ['tyt_mat', 'ayt_mat'];
        break;
    }

    final allTopics = <Topic>[];
    for (final sId in subjectIds) {
      final topics = await curriculumRepository.getTopics(sId);
      allTopics.addAll(topics);
    }

    // Tüm konuların veritabanındaki güncel ilerlemesini al
    final progressMap = <String, TopicProgress>{};
    for (final sId in subjectIds) {
      final progress = await curriculumRepository.getAllProgressForSubject(sId);
      progressMap.addAll(progress);
    }

    // Bu zincirde yer alacak ve önkoşul ilişkisine sahip olan düğümleri filtrele
    final relevantTopicIds = <String>{};
    for (final t in allTopics) {
      if (prerequisitesByTopicId.containsKey(t.id)) {
        relevantTopicIds.add(t.id);
        relevantTopicIds.addAll(prerequisitesByTopicId[t.id]!);
      }
    }

    // Bağımlılık (dependent) listesini tersine eşle
    final dependentsByTopicId = <String, List<String>>{};
    for (final entry in prerequisitesByTopicId.entries) {
      for (final prereq in entry.value) {
        dependentsByTopicId.putIfAbsent(prereq, () => []).add(entry.key);
      }
    }

    // Düğümleri sırala ve oluştur
    final nodes = <TopicNodeInfo>[];
    var rowIndex = 0.0;

    for (final t in allTopics) {
      if (!relevantTopicIds.contains(t.id)) continue;

      final p = progressMap[t.id] ?? TopicProgress(topicId: t.id);
      final prereqs = prerequisitesByTopicId[t.id] ?? const [];
      final dependents = dependentsByTopicId[t.id] ?? const [];

      // Önkoşullar tamamlanmış mı?
      final isReady = prereqs.isEmpty ||
          prereqs.every((reqId) =>
              (progressMap[reqId]?.status ?? TopicStatus.notStarted) ==
              TopicStatus.completed);

      // Tekrar gerekiyor mu? (Spaced repetition)
      var needsReview = false;
      String? reviewMessage;

      if (p.status == TopicStatus.completed) {
        final daysSinceStudy = p.lastStudiedAt != null
            ? now.difference(p.lastStudiedAt!).inDays
            : 10;
        if (daysSinceStudy >= 7) {
          needsReview = true;
          reviewMessage =
              '$daysSinceStudy gündür tekrar edilmedi. Unutma eğrisini tazele!';
        } else if (p.answeredCount < 20) {
          needsReview = true;
          reviewMessage =
              'Pekiştirme için çözülen soru sayısı az (${p.answeredCount}/20).';
        } else {
          reviewMessage = 'Konu taze ve pekiştirilmiş. Harika gidiyorsun!';
        }
      } else if (p.status == TopicStatus.inProgress) {
        reviewMessage = 'Çalışma devam ediyor. Hedef: Tamamlama.';
      } else {
        if (isReady) {
          reviewMessage = 'Tüm önkoşullar tamamlandı. Çalışmaya hazır!';
        } else {
          reviewMessage = 'Önce temel önkoşul konularını bitirmen önerilir.';
        }
      }

      // Koordinatlandırma: İki sütunlu veya aşamalı yerleşim
      final isAyt = t.subjectId.startsWith('ayt');
      final colX = isAyt ? 280.0 : 80.0;
      final posY = 40.0 + (rowIndex * 95.0);
      rowIndex += 1.0;

      nodes.add(
        TopicNodeInfo(
          topicId: t.id,
          topicName: t.name,
          subjectId: t.subjectId,
          subjectName: t.subjectId.startsWith('ayt')
              ? 'AYT ${t.subjectId.replaceAll('ayt_', '').toUpperCase()}'
              : 'TYT ${t.subjectId.replaceAll('tyt_', '').toUpperCase()}',
          stage: isAyt ? 'AYT' : 'TYT',
          prerequisiteIds: prereqs,
          dependentIds: dependents,
          status: p.status,
          answeredCount: p.answeredCount,
          lastStudiedAt: p.lastStudiedAt,
          isReady: isReady,
          needsReview: needsReview,
          reviewMessage: reviewMessage,
          x: colX,
          y: posY,
        ),
      );
    }

    return nodes;
  }

  /// Tüm sistemdeki acil tekrar önerilerini listeler (Spaced Repetition Listesi)
  Future<List<TopicNodeInfo>> getReviewRecommendations({
    DateTime? simulatedNow,
  }) async {
    final branches = ['matematik', 'fizik', 'kimya', 'biyoloji'];
    final allRecommendations = <TopicNodeInfo>[];

    for (final b in branches) {
      final nodes = await getTopicNodesForBranch(
        branchKey: b,
        simulatedNow: simulatedNow,
      );
      for (final n in nodes) {
        if (n.needsReview) {
          allRecommendations.add(n);
        }
      }
    }

    // En uzun süredir tekrar edilmeyenleri en öne sırala
    allRecommendations.sort((a, b) {
      final dateA = a.lastStudiedAt ?? DateTime(2000);
      final dateB = b.lastStudiedAt ?? DateTime(2000);
      return dateA.compareTo(dateB);
    });

    return allRecommendations;
  }
}
