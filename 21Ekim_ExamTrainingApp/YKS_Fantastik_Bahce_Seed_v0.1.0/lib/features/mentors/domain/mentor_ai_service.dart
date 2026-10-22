import 'dart:math';
import 'mentor.dart';

class MentorAiResponse {
  const MentorAiResponse({
    required this.mentor,
    required this.reply,
    required this.spellTactic,
    required this.suggestedQuestionCount,
  });

  final FantasyMentor mentor;
  final String reply;
  final String spellTactic;
  final int suggestedQuestionCount;
}

class MentorAiService {
  MentorAiService._();
  static final MentorAiService instance = MentorAiService._();

  Future<MentorAiResponse> askMentor({
    required FantasyMentor mentor,
    required String userQuestion,
  }) async {
    // Simüle edilen zeki yanıt gecikmesi (düşünme & rünleri okuma efekti)
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final lower = userQuestion.toLowerCase();

    String reply;
    String tactic;
    int targetQuestions = 25;

    switch (mentor.id) {
      case 'theron':
        if (lower.contains('trig') || lower.contains('açı')) {
          reply =
              'Trigonometri bir üçgenin içine hapsedilmiş evrensel bir danstır. Birim çemberi zihninde altın bir güneş gibi canlandır. '
              'Tüm formülleri ezberlemek yerine sin²x + cos²x = 1 ve yarım açı açılımlarını anahtar rünler olarak kabul et. '
              'Bu iki kapı, 10 farklı trigonometri kilidini aynı anda açar!';
          tactic = 'Birim çember üzerindeki işaretleri (Tüm Sınıf Kara Tahtada Coştu) formülüyle mühürle.';
          targetQuestions = 30;
        } else if (lower.contains('limit') || lower.contains('türev') || lower.contains('integral')) {
          reply =
              'Ah, değişimin kadim büyüsü! Türevi fonksiyonun her saniyedeki anlık nefesi gibi düşün. '
              'Eğer eğim sıfırsa tepeye varmışsındır ya da bir vadinin en dibindesindir. '
              'Türev alırken bileşke fonksiyonun iç türevini unutmak en yaygın dikkatsizlik tuzağıdır. Asla iç türevi es geçme!';
          tactic = 'Tepe ve çukur noktalarında f\'(x) = 0 kuralını hemen kenara not et.';
          targetQuestions = 35;
        } else if (lower.contains('geo') || lower.contains('üçgen')) {
          reply =
              'Geometride şekle bakılmaz, şekil okunur genç çırak! İkizkenar üçgen gördüğünde tepeden tabana dik indirmek '
              'sana simetrinin iki yarısını bahşeder. Muhteşem üçlüyü ise bir pusula gibi kullan.';
          tactic = 'Göremediğin sorularda şekli temiz bir kağıda 2 kat büyük çizerek ek çizgiyi ara.';
          targetQuestions = 25;
        } else {
          reply =
              'Matematik rünleri senin kararlılığından beslenir evlat. "$userQuestion" sorunun temelinde işlem disiplini yatıyor. '
              'İşlem hatasını azaltmak için adımlarını satır satır ve düzenli yaz. Hızlı çözen değil, adımlarını net gören zafere ulaşır!';
          tactic = 'Günde 30 problem çözerek zihinsel hızını kadim seviyeye yükselt.';
          targetQuestions = 30;
        }
        break;

      case 'sylva':
        if (lower.contains('kalıtım') || lower.contains('gen')) {
          reply =
              'Kalıtım, geçmişin geleceğe fısıldadığı genetik bir bahçe şarkısıdır! '
              'Eğer otozomal çekinik arıyorsan soy ağacındaki taralı bireylere "aa" yazıp ebeveynlerine doğru filizleri takip et. '
              'Büyülü sır: Taralı olmayanlarda en az bir büyük "A" olmak zorundadır!';
          tactic = 'Soy ağacı sorularında önce hasta (çekinik) bireyleri küçük harfle işaretle.';
          targetQuestions = 25;
        } else if (lower.contains('fotosentez') || lower.contains('solunum')) {
          reply =
              'Fotosentez ışığın glikoza dönüşen ruhudur; solunum ise o glikozun ATP enerjisine dönüşen ateşidir! '
              'Işığa bağımlı evrede tilakoit zarda suyun fotoliziyle oksijen salınırken, ışıktan bağımsız Calvin döngüsünde CO₂ besine bağlanır.';
          tactic = 'Işık = Grana (H₂O -> O₂), Karanlık/Enzim = Stroma (CO₂ -> Glikoz) ikilisini unutma.';
          targetQuestions = 20;
        } else {
          reply =
              'Canlılık sistemleri birbirine bağlı yaşayan kökler gibidir. "$userQuestion" konusunu kavrarken '
              'kavramları ezberlemek yerine aralarındaki ilişki haritasını çiz. Hücreden organizmaya her şey kusursuz bir düzen içindedir.';
          tactic = 'Konu bitiminde kendi cümlelerinle 5 maddelik bir biyoloji filizi özeti çıkar.';
          targetQuestions = 20;
        }
        break;

      case 'ignis':
        if (lower.contains('fizik') || lower.contains('kuvvet') || lower.contains('hareket')) {
          reply =
              'Gözlerini aç çırak! F = m · a evrenin en saf motorudur! '
              'Serbest cisim diyagramı çizmeden soruya dokunursan patlarsın! Önce cisme etki eden tüm kuvvetleri renkli oklarla çiz, '
              'ardından net kuvveti bul ve ivmeye doğru fırla!';
          tactic = 'Soruya başlamadan önce cisme etki eden yerçekimi ve sürtünme oklarını çiz.';
          targetQuestions = 30;
        } else if (lower.contains('kimya') || lower.contains('denge') || lower.contains('gaz')) {
          reply =
              'P·V = n·R·T! Paran Varsa Ne Rahat formülü boşuna söylenmedi! Gazların hacmi sıcaklıkla dans eder, basınçla sıkışır. '
              'Denge tepkimelerinde ise sistem her zaman senin yaptığın etkinin tam tersine direnç gösterir (Le Chatelier prensibi).';
          tactic = 'Dengeye sıcaklık/basınç etkisi yapıldığında sistemin nereye kayacağını okla belirt.';
          targetQuestions = 25;
        } else {
          reply =
              'Simya ve doğa kanunları yanılmaz! "$userQuestion" konusunda takıldıysan formüllere değil mantığına odaklan. '
              'Birim analizi yap; Newton/Metrekare = Pascal olduğunu hatırladığın an formül ezberine gerek kalmaz!';
          tactic = 'Birimleri sadeleştirerek cevabın boyutunu kontrol et.';
          targetQuestions = 25;
        }
        break;

      case 'valerius':
      default:
        if (lower.contains('paragraf') || lower.contains('türkçe') || lower.contains('şık')) {
          reply =
              'Kelimelerin labirentinde kaybolma yolcu! İki şık arasında kaldığında metnin dışına çıkıyorsun demektir. '
              'Kendi genel kültürünü unut; metinde yazar ne söylüyorsa mutlak hakikat odur. '
              'İlk ve son cümleler ana fikrin fenerleridir; ancak "oysa, fakat, asıl önemli olan" bağlaçlarından sonra gelen cümle yazarın kalbidir!';
          tactic = 'Soruyu okumadan önce soru kökündeki olumsuz ifadeyi (-memiştir) daire içine al.';
          targetQuestions = 35;
        } else if (lower.contains('edebiyat') || lower.contains('yazar') || lower.contains('eser')) {
          reply =
              'Dönemlerin ruhunu anlarsan eserler kendiliğinden aklına nakşolur. Divan şairlerinin mazmunları ve '
              'Cumhuriyet aydınlarının memleket edebiyatı sevdası... Yazarları kronolojik bir zaman çizelgesinde arkadaş gibi tanı.';
          tactic = 'Yazarları anahtar temaları ve en bilinen üç eseriyle kartlara yaz.';
          targetQuestions = 25;
        } else {
          reply =
              'Zihnini bir göl gibi dingin tut. "$userQuestion" sorusu için sana tavsiyem: '
              'Sınav anında acele eden değil, odaklanmış bir dikkatle her kelimenin ağırlığını hisseden zirveye çıkar.';
          tactic = 'Her gün sabah zihnin berrakken 20 paragraf sorusunu aralıksız süre tutarak çöz.';
          targetQuestions = 20;
        }
        break;
    }

    final randomBonus = Random().nextInt(5);
    return MentorAiResponse(
      mentor: mentor,
      reply: reply,
      spellTactic: tactic,
      suggestedQuestionCount: targetQuestions + randomBonus,
    );
  }
}
