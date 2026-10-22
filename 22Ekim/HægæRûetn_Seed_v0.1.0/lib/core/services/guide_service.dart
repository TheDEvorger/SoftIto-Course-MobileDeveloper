abstract class GuideService {
  String reply(String input, GuideTone tone);
  String systemInstruction(GuideTone tone);
}

enum GuideTone { commander, sage, companion }

/// Offline demo. No LLM, backend, or network calls are made.
class OfflineGuideService implements GuideService {
  @override
  String systemInstruction(GuideTone tone) => switch (tone) {
    GuideTone.commander => 'Kullanıcıyı kararlı ama saygılı bir komutan gibi destekle. Zorlamadan mikro hedef öner.',
    GuideTone.sage => 'Kullanıcıyı yargılamadan dinle, sakin ve düşünceli şekilde küçük adım sun.',
    GuideTone.companion => 'Sıcak, doğal ve samimi konuş. Tek uygulanabilir küçük adım öner.',
  };

  @override
  String reply(String input, GuideTone tone) {
    final text = input.toLowerCase();
    if (text.contains('yorgun') || text.contains('zor') || text.contains('bırak') || text.contains('vazgeç')) {
      return switch (tone) {
        GuideTone.commander => 'Yolcu! Bugünkü cephemiz küçük: yalnızca beş dakika. Sonra dinlenmeyi yeniden değerlendir.',
        GuideTone.sage => 'Bazen ilerlemek yükü azaltmaktır. Beş dakikalık bir deneme veya planlı istirahat seçebilirsin.',
        GuideTone.companion => 'Anlıyorum, bugün kolay geçmiyor. Beş dakika deneyebilir ya da hakkın olan bir mola verebilirsin.',
      };
    }
    if (text.contains('başard') || text.contains('bitti') || text.contains('tamamlad')) {
      return 'Borazanlar çalıyor! ✨ Başardığın şeyi kroniğine ekle. Sonraki adımı küçük ve sürdürülebilir tut.';
    }
    return switch (tone) {
      GuideTone.commander => 'Ferman açık: bir vazife seç, onu on dakikaya böl ve başla. Düzen, iradenin zırhıdır.',
      GuideTone.sage => 'Bugün hangi küçük adım seni hedefine yaklaştırır? On dakikalık bir başlangıç iyi olabilir.',
      GuideTone.companion => 'Beraber minicik bir adım seçelim. Hangi vazifeyi bugün biraz ilerletebiliriz?',
    };
  }
}
