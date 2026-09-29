// Hizmet kategorilerini sabit seçenekler halinde tutuyoruz
enum HizmetKategorisi {
  // Cilt yenileme işlemleri için
  ciltYenileme,

  // Medikal estetik işlemleri için
  medikalEstetik,

  // Lazer epilasyon işlemleri için
  lazerEpilasyon,

  // Lipo işlemleri için
  Lipo
}

// Seansın hangi durumda olduğunu tutuyoruz
enum SeansDurumu {
  // Seans henüz başlamadıysa
  bekliyor,

  // Danışan odada işlem görüyorsa
  odadaIslemde,

  // Seans tamamlandıysa
  tamamlandi,

  // Seans iptal edildiyse
  iptalEdildi
}

// Kullanılabilecek ödeme yöntemlerini tutuyoruz
enum OdemeYontemi {
  // Kredi kartı ile ödeme
  krediKarti,

  // Havale veya EFT ile ödeme
  havaleEft,

  // Nakit ödeme
  nakit,

  // Kliniğin paket kredisi ile ödeme
  klinikPaketKredisi
}

// Danışan bilgilerini tutmak için sınıf oluşturuyoruz
class Danisan {

  // Danışanın sistemdeki id bilgisini tutuyor
  final String id;

  // Danışanın ad ve soyad bilgisini tutuyor
  final String adSoyad;

  // Danışanın telefon numarasını tutuyor
  final String telefon;

  // Danışanın VIP üye olup olmadığını tutuyor
  final bool vipUyeMi;

  // Danışanın alerjilerini liste halinde tutuyor
  final List<String> alerjiler;

  // Özel cilt notu olmayabileceği için nullable tanımlıyoruz
  final String? ozelCiltNotu;

  // Danışan nesnesini oluşturmak için constructor
  const Danisan({

    // Id bilgisi zorunlu
    required this.id,

    // Ad soyad bilgisi zorunlu
    required this.adSoyad,

    // Telefon bilgisi zorunlu
    required this.telefon,

    // Değer gönderilmezse VIP üyelik false olacak
    this.vipUyeMi = false,

    // Alerji gönderilmezse boş liste kullanıyoruz
    this.alerjiler = const [],

    // Özel cilt notu zorunlu değil
    this.ozelCiltNotu,
  });

  // Alerji listesi boş değilse hassas cilt olarak kabul ediyoruz
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  // Danışanın bilgilerini tek bir metin halinde hazırlıyoruz
  String get bilgiOzeti {

    // Alerji listesi boşsa varsayılan mesaj, değilse listedeki alerjiler yazılıyor
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";

    // Özel cilt notu null ise varsayılan metni kullanıyoruz
    final String notBilgisi =
        ozelCiltNotu ?? "Özel medikal not girilmemiş";

    // VIP durumuna göre ekranda gösterilecek yazıyı belirliyoruz
    final String vipRozeti =
        vipUyeMi ? "VİP" : "Standart";

    // Hazırladığımız bütün bilgileri tek satır olarak döndürüyoruz
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seansla ilgili bilgileri tutmak için sınıf oluşturuyoruz
class SeansKaydi {

  // Her seansın kendine ait kodunu tutuyor
  final String seansKodu;

  // Bu seansın hangi danışana ait olduğunu tutuyor
  final Danisan danisan;

  // Seansın hangi hizmet kategorisinde olduğunu tutuyor
  final HizmetKategorisi kategori;

  // Yapılacak işlemin adını tutuyor
  final String islemAdi;

  // Seansın birim fiyatını tutuyor
  final double birimFiyat;

  // Toplam kaç seans yapılacağını tutuyor
  final int seansSayisi;

  // Uygulanacak indirim oranını tutuyor
  final double indirimOrani;

  // Uzman atanmayabileceği için nullable tanımlıyoruz
  final String? sorumluUzman;

  // Seansın durumu sonradan değişebileceği için final kullanmıyoruz
  SeansDurumu durum;

  // Ödeme henüz yapılmamış olabileceği için nullable
  OdemeYontemi? odemeTipi;

  // Yeni bir seans kaydı oluşturmak için constructor
  SeansKaydi({

    // Seans kodu zorunlu
    required this.seansKodu,

    // Danışan bilgisi zorunlu
    required this.danisan,

    // Hizmet kategorisi zorunlu
    required this.kategori,

    // İşlem adı zorunlu
    required this.islemAdi,

    // Birim fiyat zorunlu
    required this.birimFiyat,

    // Seans sayısı verilmezse 1 kabul ediyoruz
    this.seansSayisi = 1,

    // İndirim verilmezse yüzde 0 kabul ediyoruz
    this.indirimOrani = 0.0,

    // Sorumlu uzman zorunlu değil
    this.sorumluUzman,

    // Durum verilmezse seans bekliyor olarak başlıyor
    this.durum = SeansDurumu.bekliyor,

    // Ödeme bilgisi başlangıçta boş olabilir
    this.odemeTipi,
  });

  // Birim fiyat ile seans sayısını çarpıp brüt tutarı hesaplıyoruz
  double get brutTutar => birimFiyat * seansSayisi;

  // Toplam indirim tutarını hesaplayan getter
  double get indirimTutari {

    // İlk olarak normal indirim oranını alıyoruz
    double toplamOran = indirimOrani;

    // Danışan VIP üye ise ek indirim uyguluyoruz
    if (danisan.vipUyeMi) {

      // VIP üyeye yüzde 10 daha ekliyoruz
      toplamOran += 10.0;
    }

    // Brüt tutardan toplam indirim miktarını hesaplayıp döndürüyoruz
    return brutTutar * (toplamOran / 100.0);
  }

  // Brüt tutardan indirimi çıkarıp ödenecek net tutarı buluyoruz
  double get netTutar => brutTutar - indirimTutari;
}

// Klinik içindeki danışan ve seans işlemlerini yönetecek sınıf
class KlinikYoneticisi {

  // Hangi şube ile çalıştığımızı tutuyor
  final String subeAdi;

  // Oluşturulan seans kayıtlarını listede saklıyoruz
  final List<SeansKaydi> _seanslar = [];

  // Danışanları id bilgisine göre Map içinde tutuyoruz
  final Map<String, Danisan> _danisanRehberi = {};

  // Klinik yöneticisini oluştururken şube adı zorunlu
  KlinikYoneticisi({
    required this.subeAdi,
  });

  // Yeni danışanı rehbere eklemek için metot
  void danisanKaydet(Danisan danisan) {

    // Danışanı kendi id bilgisiyle Map içine ekliyoruz
    _danisanRehberi[danisan.id] = danisan;

    // Eklenen danışanın bilgisini ekrana yazdırıyoruz
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  // Yeni seans kaydını sisteme eklemek için metot
  void randevuOlustur(SeansKaydi seans) {

    // Gelen seansı seans listesine ekliyoruz
    _seanslar.add(seans);

    // Kaydedilen randevunun temel bilgilerini yazdırıyoruz
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  // Seansı tamamlayıp ödeme bilgisini kaydetmek için metot
  void seansiTamamla({
    required String seansKodu,
    required OdemeYontemi odeme,
  }) {

    // Listedeki bütün seansları sırayla kontrol ediyoruz
    for (var seans in _seanslar) {

      // Aradığımız seans kodu bulunduysa işlem yapıyoruz
      if (seans.seansKodu == seansKodu) {

        // Seansın durumunu tamamlandı olarak değiştiriyoruz
        seans.durum = SeansDurumu.tamamlandi;

        // Kullanılan ödeme yöntemini kaydediyoruz
        seans.odemeTipi = odeme;

        // Tamamlanan seansın tahsil edilen tutarını yazdırıyoruz
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
      }
    }

    // Döngü bittikten sonra hata mesajını yazdırıyoruz
    print("Hata [$seansKodu] kodlu seans bulunamadı");

    // Metottan çıkıyoruz
    return;
  }

  // Belirli bir seansı iptal etmek için metot
  void seansiIptalEt(
    String seansKodu, {
    String? iptalNedeni,
  }) {

    // Sistemdeki bütün seansları kontrol ediyoruz
    for (var seans in _seanslar) {

      // Gönderilen kod ile eşleşen seansı buluyoruz
      if (seans.seansKodu == seansKodu) {

        // Seansın durumunu iptal edildi olarak değiştiriyoruz
        seans.durum = SeansDurumu.iptalEdildi;

        // İptal nedeni varsa onu, yoksa varsayılan mesajı yazdırıyoruz
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );

        // Seansı bulduğumuz için metottan çıkıyoruz
        return;
      }
    }
  }

  // Tamamlanan seanslardan elde edilen toplam ciroyu hesaplıyoruz
  double get toplamTahsilEdilenCiro =>

      // Sadece durumu tamamlandı olan seansları seçiyoruz
      _seanslar.where((s) => s.durum == SeansDurumu.tamamlandi)

      // Seçilen seansların net tutarlarını toplayıp tek bir değer elde ediyoruz
      .fold(0.0, (toplam, s) => toplam + s.netTutar);


  // Henüz tamamlanmamış ama gelir oluşturabilecek seansların toplamını hesaplıyoruz
  double get beklenenPotansiyelCiro =>

      // Bekleyen veya işlemde olan seansları seçiyoruz
      _seanslar.where(

        // Seans bekliyorsa veya odada işlemdeyse listeye dahil ediyoruz
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )

      // Seçilen seansların net tutarlarını topluyoruz
      .fold(0.0, (toplam, s) => toplam + s.netTutar);


  // Her kategoride kaç seans olduğunu tutacak Map yapısını oluşturuyoruz
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {

    // Kategori ve seans sayısını tutacak boş Map oluşturuyoruz
    final Map<HizmetKategorisi, int> dagilim = {};

    // Enum içindeki bütün hizmet kategorilerini sırayla geziyoruz
    for (var kat in HizmetKategorisi.values) {

      // Başlangıçta her kategorinin seans sayısını 0 yapıyoruz
      dagilim[kat] = 0;
    }

    // Sistemdeki bütün seansları geziyoruz
    for (var s in _seanslar) {

      // Seansın kategorisinin sayısını 1 arttırıyoruz
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }

    // Hazırlanan kategori dağılımını geri döndürüyoruz
    return dagilim;
  }


  // Görevli uzmanları tekrar etmeyecek şekilde Set olarak döndürüyoruz
  Set<String> gorevliUzmanKadrosu() {

    // Seanslardan uzman isimlerini alıp null olanları çıkarıp Set'e çeviriyoruz
    return _seanslar
        .map((s) => s.sorumluUzman)
        .whereType<String>()
        .toSet();
  }

  // Henüz uzman atanmamış seansları liste halinde getiriyoruz
  List<SeansKaydi> uzmansizSeanslariGetir() {

    // Sorumlu uzmanı null olan seansları filtreleyip listeye çeviriyoruz
    return _seanslar
        .where((s) => s.sorumluUzman == null)
        .toList();
  }

  // Gün sonu raporunu ekrana yazdırmak için metot
  void gunSonuRaporuYazdir() {

    // Raporun başlığını yazdırıyoruz
    print("Günlük Seans ve İşlem Çizelgesi");

    // Başlığı ayırmak için çizgi yazdırıyoruz
    print("---------------------------------------");

    // Tablo sütunlarının başlıklarını hazırlıyoruz
    print(

      // Kod başlığını 10 karakterlik alan içinde hizalıyoruz
      "${'Kod'.padRight((10))} | "

      // Danışan başlığını 16 karakterlik alanda hizalıyoruz
      "${'Danışan'.padRight(16)} | "

      // İşlem başlığını 20 karakterlik alanda hizalıyoruz
      "${'İşlem'.padRight(20)} | "

      // Uzman başlığını 18 karakterlik alanda hizalıyoruz
      "${'Uzman'.padRight(18)} | "

      // Tutar başlığını 10 karakterlik alanda hizalıyoruz
      "${'Tutar'.padRight(10)} | "

      // Son sütunda seansın durumunu göstereceğiz
      "${'Durum'} | ",
    );

    // Tablo başlığı ile kayıtları ayırıyoruz
    print("---------------------------------------");


    // Sistemde bulunan bütün seansları sırayla geziyoruz
    for (var s in _seanslar) {

      // Uzman yoksa ekranda nöbetçi bekliyor yazısını gösteriyoruz
      final String uzman =
          s.sorumluUzman ?? " Nöbetçi Bekliyor";

      // Seans durumuna göre ekranda gösterilecek yazıyı belirliyoruz
      final String durumRozet = switch (s.durum) {

        // Tamamlanan seanslarda Tamamlandı yazıyoruz
        SeansDurumu.tamamlandi => "Tamamlandı",

        // Devam eden seanslarda İşlemde yazıyoruz
        SeansDurumu.odadaIslemde => "İşlemde",

        // Henüz başlamayan seanslarda Bekliyor yazıyoruz
        SeansDurumu.bekliyor => "Bekliyor",

        // İptal edilen seanslarda İptal yazıyoruz
        SeansDurumu.iptalEdildi => "İptal",
      };


      // Seansın bütün bilgilerini tablo satırı olarak yazdırıyoruz
      print(

        // Seans kodunu 10 karakterlik alanda gösteriyoruz
        "${s.seansKodu.padRight(10)} | "

        // Danışanın adını 10 karakterlik alanda gösteriyoruz
        "${s.danisan.adSoyad.padRight(10)} | "

        // Yapılan işlemi 10 karakterlik alanda gösteriyoruz
        "${s.islemAdi.padRight(10)} | "

        // Sorumlu uzmanı 10 karakterlik alanda gösteriyoruz
        "${uzman.padRight(10)} | "

        // Net tutarı iki ondalık basamakla gösteriyoruz
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "

        // Daha önce belirlediğimiz durum yazısını ekliyoruz
        "$durumRozet",
      );
    }

    // Seans listesinin sonuna ayırıcı çizgi ekliyoruz
    print("---------------------------------------");

    // Finansal özet bölümünün başlığını yazdırıyoruz
    print("Finansal Özet:");

    // Tamamlanan seanslardan elde edilen toplam net ciroyu yazdırıyoruz
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );

    // Bekleyen ve işlemdeki seansların potansiyel tutarını yazdırıyoruz
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );

    // Sistemde toplam kaç seans olduğunu yazdırıyoruz
    print(" * Toplam Seans : ${_seanslar.length} Randevu");

    // Finans bölümünün sonuna ayırıcı çizgi ekliyoruz
    print("---------------------------------------");

    // Aktif uzmanlar bölümünün başlığını yazdırıyoruz
    print("Aktif Uzmanlar");

    // Görevli uzmanları Set olarak alıyoruz
    final uzmanlar = gorevliUzmanKadrosu();

    // Uzman listesi boşsa kontrol ediyoruz
    if (uzmanlar.isEmpty) {

      // Hiç uzman yoksa bilgi mesajı yazdırıyoruz
      print("Kayıtlı Uzman Bulunamadı");

    // Uzman varsa bu kısma giriyoruz
    } else {

      // Uzman isimlerini virgülle ayırarak tek satırda yazdırıyoruz
      print(" ${uzmanlar.join(', ')}");
    }


    // Uzman atanmamış seansları liste olarak alıyoruz
    final uzmansizlar = uzmansizSeanslariGetir();

    // Uzmansız seans varsa uyarı bölümünü çalıştırıyoruz
    if (uzmansizlar.isNotEmpty) {

      // Kaç tane uzmansız seans olduğunu yazdırıyoruz
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );

      // Uzmansız seansların hepsini sırayla geziyoruz
      for (var u in uzmansizlar) {

        // Seans kodunu, danışanı ve işlemi ekrana yazdırıyoruz
        print(
          "->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})",
        );
      }
    }

    // Raporun sonuna kapanış çizgisi ekliyoruz
    print("---------------------------------------");
  }
}

// Programın çalışmaya başladığı ana fonksiyon
void main() {

  // Klinik yönetim sistemi başlangıç mesajını yazdırıyoruz
  print("Klinik yönetim sistemi başlatılıyor....");

  // Klinik yöneticisini oluşturup hangi şubede çalıştığını belirtiyoruz
  final yonetici =
      KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");


  // İlk danışanı oluşturuyoruz
  final d1 = Danisan(

    // Danışanın sistemdeki id bilgisini veriyoruz
    id: "DAN-101",

    // Danışanın ad soyad bilgisini giriyoruz
    adSoyad: "Ahmet Yılmaz",

    // Danışanın telefon numarasını giriyoruz
    telefon: "0555 555 55 55",

    // Bu danışanın VIP üye olduğunu belirtiyoruz
    vipUyeMi: true,

    // Danışanın kayıtlı alerjilerini liste halinde giriyoruz
    alerjiler: ["Retinol,Aspirin"],

    // Danışan için özel cilt notu ekliyoruz
    ozelCiltNotu: "Cilt bariyeri hassas",
  );


  // İkinci danışanı oluşturuyoruz
  final d2 = Danisan(

    // İkinci danışanın id bilgisini veriyoruz
    id: "DAN-102",

    // Danışanın ad soyad bilgisini giriyoruz
    adSoyad: "Ahmet Yılan",

    // Telefon numarasını giriyoruz
    telefon: "0555 555 55 55",

    // VIP üye olmadığı için false veriyoruz
    vipUyeMi: false,

    // Kayıtlı alerji olmadığı için boş liste gönderiyoruz
    alerjiler: [],
  );


  // Üçüncü danışanı oluşturuyoruz
  final d3 = Danisan(

    // Danışanın id bilgisini veriyoruz
    id: "DAN-103",

    // Ad soyad bilgisini giriyoruz
    adSoyad: "Mehmet Yılmaz",

    // Telefon numarasını giriyoruz
    telefon: "0555 555 55 55",

    // Bu danışanın da VIP olduğunu belirtiyoruz
    vipUyeMi: true,

    // Kayıtlı alerjileri listeye ekliyoruz
    alerjiler: ["Retinol,Aspirin"],
  );


  // Dördüncü danışanı oluşturuyoruz
  final d4 = Danisan(

    // Danışanın id bilgisini giriyoruz
    id: "DAN-104",

    // Ad soyad bilgisini giriyoruz
    adSoyad: "Ahmet Mehmet Yılmaz",

    // Telefon numarasını giriyoruz
    telefon: "0555 555 55 55",

    // VIP üyelik durumunu true yapıyoruz
    vipUyeMi: true,

    // Kayıtlı alerji olmadığı için boş liste gönderiyoruz
    alerjiler: [],

    // Danışanın özel cilt notunu giriyoruz
    ozelCiltNotu: "Cilt bariyeri hassas",
  );


  // İlk danışanı klinik rehberine kaydediyoruz
  yonetici.danisanKaydet(d1);

  // İkinci danışanı klinik rehberine kaydediyoruz
  yonetici.danisanKaydet(d2);

  // Üçüncü danışanı klinik rehberine kaydediyoruz
  yonetici.danisanKaydet(d3);

  // Dördüncü danışanı klinik rehberine kaydediyoruz
  yonetici.danisanKaydet(d4);


  // Danışan güvenlik kontrolü başlığını yazdırıyoruz
  print("Danışan güvenlik kontrolü");

  // İlk danışanın hazırlanan bilgi özetini yazdırıyoruz
  print(d1.bilgiOzeti);

  // İkinci danışanın bilgi özetini yazdırıyoruz
  print(d2.bilgiOzeti);

  // Ekrandaki bölümleri ayırmak için çizgi yazdırıyoruz
  print("----------------------------------");

    // İlk seans kaydını oluşturuyoruz
  final seans1 = SeansKaydi(

    // Seansa ait kodu giriyoruz
    seansKodu: "SNS-2026-1",

    // Bu seansın d1 danışanına ait olduğunu belirtiyoruz
    danisan: d1,

    // Hizmet kategorisini Lipo olarak seçiyoruz
    kategori: HizmetKategorisi.Lipo,

    // Yapılacak işlemin adını giriyoruz
    islemAdi: "Lipo gerisini bilmiyorum",

    // Bir seansın fiyatını giriyoruz
    birimFiyat: 6500.0,

    // Toplam seans sayısını belirliyoruz
    seansSayisi: 2,

    // İndirim oranını yüzde 5 olarak belirliyoruz
    indirimOrani: 5.0,

    // Bu seansa sorumlu uzman atıyoruz
    sorumluUzman: "Sümeyye Arab",
  );


  // İkinci seans kaydını oluşturuyoruz
  final seans2 = SeansKaydi(

    // İkinci seansın kodunu giriyoruz
    seansKodu: "SNS-2026-2",

    // Bu seansın d2 danışanına ait olduğunu belirtiyoruz
    danisan: d2,

    // Hizmet kategorisini cilt yenileme olarak seçiyoruz
    kategori: HizmetKategorisi.ciltYenileme,

    // Yapılacak işlemin adını giriyoruz
    islemAdi: "Siverex ile tyüz temizleme",

    // Bir seansın fiyatını giriyoruz
    birimFiyat: 2500.0,

    // Toplam 5 seans uygulanacağını belirtiyoruz
    seansSayisi: 5,

    // İndirim oranını yüzde 15 olarak belirliyoruz
    indirimOrani: 15.0,

    // Henüz uzman atanmadığı için null veriyoruz
    sorumluUzman: null,
  );


  // Üçüncü seans kaydını oluşturuyoruz
  final seans3 = SeansKaydi(

    // Üçüncü seansın kodunu giriyoruz
    seansKodu: "SNS-2026-3",

    // Bu seansın d3 danışanına ait olduğunu belirtiyoruz
    danisan: d3,

    // Hizmet kategorisini lazer epilasyon olarak seçiyoruz
    kategori: HizmetKategorisi.lazerEpilasyon,

    // Yapılacak işlemi belirtiyoruz
    islemAdi: "Tüm Vücut",

    // Bir seansın fiyatını giriyoruz
    birimFiyat: 25000.0,

    // Toplam 15 seans uygulanacağını belirtiyoruz
    seansSayisi: 15,

    // Manuel indirim oranını 0 olarak belirliyoruz
    indirimOrani: 0.0,

    // Seansa sorumlu uzman atıyoruz
    sorumluUzman: "Tuba Aydın",
  );


  // Dördüncü seans kaydını oluşturuyoruz
  final seans4 = SeansKaydi(

    // Dördüncü seansın kodunu giriyoruz
    seansKodu: "SNS-2026-4",

    // Bu seansın d4 danışanına ait olduğunu belirtiyoruz
    danisan: d4,

    // Hizmet kategorisini medikal estetik olarak seçiyoruz
    kategori: HizmetKategorisi.medikalEstetik,

    // Yapılacak işlemin adını giriyoruz
    islemAdi: "Burun Estetiği",

    // Bir seansın fiyatını giriyoruz
    birimFiyat: 1500.0,

    // Toplam 3 seans uygulanacağını belirtiyoruz
    seansSayisi: 3,

    // Bu seansa sorumlu uzman atıyoruz
    sorumluUzman: "Alaaddin Odabaşı",
  );


  // İlk seans kaydını yöneticiye gönderiyoruz
  yonetici.randevuOlustur(seans1);

  // İkinci seans kaydını yöneticiye gönderiyoruz
  yonetici.randevuOlustur(seans2);

  // Üçüncü seans kaydını yöneticiye gönderiyoruz
  yonetici.randevuOlustur(seans3);

  // Dördüncü seans kaydını yöneticiye gönderiyoruz
  yonetici.randevuOlustur(seans4);

  // Seans gönderim mesajını ekrana yazdırıyoruz
  print("Seanslar Gönderiliyor");


  // İlk seansı tamamlanmış olarak işaretliyoruz
  yonetici.seansiTamamla(

    // Tamamlanacak seansın kodunu gönderiyoruz
    seansKodu: "SNS-2026-1",

    // Ödeme yöntemi olarak kredi kartını seçiyoruz
    odeme: OdemeYontemi.krediKarti,
  );


  // İkinci seansı tamamlanmış olarak işaretliyoruz
  yonetici.seansiTamamla(

    // Tamamlanacak seansın kodunu gönderiyoruz
    seansKodu: "SNS-2026-2",

    // Ödeme yöntemi olarak nakit seçiyoruz
    odeme: OdemeYontemi.nakit,
  );


  // Seans iptali için metodu çağırıyoruz
  yonetici.seansiIptalEt(

    // İptal işlemi için seans kodunu gönderiyoruz
    "SNS-2026-04",

    // Seansın neden iptal edildiğini belirtiyoruz
    iptalNedeni:
        "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );


  // Gün sonunda bütün seans ve finans bilgilerini rapor halinde yazdırıyoruz
  yonetici.gunSonuRaporuYazdir();
}