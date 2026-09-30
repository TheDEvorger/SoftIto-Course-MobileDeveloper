// enum, bir değişkenin alabileceği seçenekleri önceden belirlememizi sağlıyor.
// Burada cihaz tipi için sadece belirlediğimiz dört seçenek kullanılacağı için enum kullandım.
enum CihazTipi {
  sensor,
  gateway,
  edgeServer,
  router
}

// class, aynı yapıya sahip nesneleri oluşturmak için kullandığımız bir şablondur.
// Ağdaki bütün IoT cihazlarının ortak özelliklerini tek yapıda tutmak için IoTCihaz sınıfını oluşturdum.
class IoTCihaz {

  // final, ilk değer verildikten sonra değişkenin tekrar değiştirilmesini engelliyor.
  // Cihaz oluşturulduktan sonra bu temel bilgilerin değişmesini istemediğim için alanları final yaptım.
  final String seriNo;
  final String cihazAdi;

  // CihazTipi, yukarıda enum ile oluşturduğum kendi veri tipimdir.
  // Böylece cihaz tipi sadece enum içindeki seçeneklerden biri olabilir.
  final CihazTipi tip;

  // CPU kullanımı 48.5 veya 91.4 gibi ondalıklı değerler alabileceği için double kullandım.
  final double cpuYukYuzdesi;

  // Bellek miktarını MB olarak tam sayı tuttuğum için int kullandım.
  final int bellekMb;

  // Set, aynı elemanın birden fazla kez bulunmasına izin vermeyen bir koleksiyondur.
  // Aynı portu iki kere tutmaya gerek olmadığı için açık portlarda Set<String> kullandım.
  final Set<String> acikPortlar;

  // SSL sertifikasının geçerli olup olmadığı sadece true veya false olabileceği için bool kullandım.
  final bool sslSertifikasiGecerliMi;

  // Cihazın açık veya kapalı olma durumu da iki seçenekli olduğu için bool kullandım.
  final bool acikMi;

  // Constructor, IoTCihaz sınıfından yeni bir cihaz oluştururken başlangıç değerlerini vermemi sağlıyor.
  // required yazdığım alanların cihaz oluşturulurken mutlaka verilmesi gerekiyor.
  // this.seriNo gibi kullanımlarda constructor'a gelen değeri sınıfın kendi alanına aktarıyorum.
  IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,

    // acikMi özellikle verilmezse cihazı varsayılan olarak açık kabul ediyorum.
    this.acikMi = true,
  });

  // Getter, bir bilgiyi ayrıca değişkende saklamak yerine mevcut bilgilerden hesaplayıp özellik gibi kullanmamı sağlıyor.
  // ! bool değeri tersine çeviriyor, contains() ise Set içinde verdiğim değerin bulunup bulunmadığına bakıyor.
  // || "veya" anlamına geliyor ve iki şarttan birinin doğru olması sonucun true olması için yeterli oluyor.
  // => tek satırlık sonucu doğrudan döndürdüğü için ayrıca return yazmam gerekmiyor.
  // SSL geçersizse veya 23/TELNET portu açıksa cihazda güvenlik açığı olduğunu kabul ediyorum.
  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi ||
      acikPortlar.contains("23/TELNET");
}

// Exception, program çalışırken oluşan hataları temsil etmek için kullanılıyor.
// Cihazın kapalı olması durumunu diğer hatalardan ayırmak için kendi exception sınıfımı oluşturdum.
// implements Exception yazarak bu sınıfı bir exception türü olarak kullanabiliyorum.
class CihazErisilemezException implements Exception {

  // Hata oluştuğunda göstermek istediğim mesajı burada tutuyorum.
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  // @override ile toString() metodunun mevcut davranışını değiştiriyorum.
  // Böylece exception ekrana yazdırıldığında verdiğim hata mesajı doğrudan görünüyor.
  @override
  String toString() => mesaj;
}

// Record, bir fonksiyondan farklı tiplerde birden fazla bilgiyi tek sonuç içinde döndürmemizi sağlıyor.
// Burada cihaz adı, cihaz tipi ve alarm durumunu birlikte döndürmek istediğim için named Record kullandım.
({
  String cihazAdi,
  CihazTipi tip,
  bool alarmDurumu
})
cihazdanBilgiyiAl(
  List<IoTCihaz> devices,
  String seriNo,
) {

  // for-in döngüsü ile listedeki cihazları sırayla kontrol ediyorum.
  // var kullandığımda değişkenin tipini Dart kendisi belirliyor ve burada device bir IoTCihaz nesnesini temsil ediyor.
  for (var device in devices) {

    // O an baktığım cihazın seri numarası aradığım seri numarasıyla aynıysa doğru cihazı bulmuş oluyorum.
    if (device.seriNo == seriNo) {

      // Cihaz sistemde kayıtlı olsa bile kapalıysa bilgi sorgusuna devam etmek istemiyorum.
      // throw, normal akışı durdurup belirlediğim exception'ı fırlatıyor.
      if (!device.acikMi) {
        throw CihazErisilemezException(
          "Cihaz kapalı ve erişilemiyor"
        );
      }

      // return ile bulduğum cihazın bilgilerini Record olarak fonksiyonun çağrıldığı yere geri döndürüyorum.
      // Güvenlik açığı varsa veya CPU kullanımı %85'in üzerindeyse alarm durumunu true yapıyorum.
      return (
        cihazAdi: device.cihazAdi,
        tip: device.tip,
        alarmDurumu:
            device.guvenlikAcigiVarMi ||
            device.cpuYukYuzdesi > 85
      );
    }
  }

  // Liste tamamen dolaşıldığı halde seri numarası bulunamadıysa cihazın sistemde olmadığını belirten hata fırlatıyorum.
  throw Exception(
    "Cihaz mevcut değil ya da bulunamadı"
  );
}

// Switch Expression, bir değeri farklı seçeneklerle karşılaştırıp eşleşen sonucun doğrudan döndürülmesini sağlıyor.
// Burada cihaz tipini uygun güvenlik izolasyon bölgesiyle eşleştirmek için Switch Expression kullandım.
String izolasyonBolgesi(CihazTipi tip) {
  return switch (tip) {
    CihazTipi.sensor => "SensorBolgesi",
    CihazTipi.gateway => "GatewayBolgesi",
    CihazTipi.edgeServer => "EdgeServerBolgesi",
    CihazTipi.router => "RouterBolgesi",
  };
}

// main(), Dart programının çalışmaya başladığı giriş noktasıdır.
// Cihazları oluşturma, listeye ekleme, filtreleme ve sonuçları gösterme işlemlerini burada yapıyorum.
void main() {

  // Testlerde kullanmak için akıllı tarla sistemine ait farklı IoT cihazları oluşturuyorum.

  final multispektralSensor = IoTCihaz(
    seriNo: "AGRI-MSI-001",
    cihazAdi: "Multispektral Bitki Görüntüleme Sensörü",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 48.5,
    bellekMb: 1024,
    acikPortlar: {"443/HTTPS"},
    sslSertifikasiGecerliMi: true,
  );

  final edgeAiSunucusu = IoTCihaz(
    seriNo: "AGRI-EDGE-001",
    cihazAdi: "Edge AI Tarım Sunucusu",
    tip: CihazTipi.edgeServer,

    // Bu cihazın CPU değerini özellikle %85'in üzerinde verdim.
    // Böylece güvenlik açığı olmasa bile yüksek CPU nedeniyle riskli cihazlara girecek.
    cpuYukYuzdesi: 91.4,

    bellekMb: 8192,
    acikPortlar: {
      "22/SSH",
      "443/HTTPS",
      "8883/MQTTS"
    },
    sslSertifikasiGecerliMi: true,
  );

  final rtkGnssAlicisi = IoTCihaz(
    seriNo: "AGRI-GNSS-001",
    cihazAdi: "RTK GNSS Konum Alıcısı",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 32.7,
    bellekMb: 256,
    acikPortlar: {"443/HTTPS"},

    // Bu cihazda SSL sertifikasını geçersiz yaptım.
    // Böylece güvenlik açığı getter'ının SSL kontrolünü de test etmiş oluyorum.
    sslSertifikasiGecerliMi: false,
  );

  final yaprakIslaklikSensoru = IoTCihaz(
    seriNo: "AGRI-LWS-001",
    cihazAdi: "Yaprak Islaklık Sensörü",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 8.2,
    bellekMb: 32,

    // Bu cihazda açık port olmadığı için boş bir Set kullandım.
    acikPortlar: {},

    sslSertifikasiGecerliMi: true,
  );

  final meteorolojiIstasyonu = IoTCihaz(
    seriNo: "AGRI-WTH-001",
    cihazAdi: "Tarım Meteoroloji İstasyonu",
    tip: CihazTipi.sensor,
    cpuYukYuzdesi: 57.8,
    bellekMb: 512,

    // Bu cihazda 23/TELNET portunu açık bıraktım.
    // Böylece güvenlik açığı getter'ındaki diğer şartı da test etmiş oluyorum.
    acikPortlar: {
      "80/HTTP",
      "23/TELNET"
    },

    sslSertifikasiGecerliMi: true,
  );

  final loraWanGateway = IoTCihaz(
    seriNo: "AGRI-LORA-001",
    cihazAdi: "LoRaWAN Tarım Gateway",
    tip: CihazTipi.gateway,
    cpuYukYuzdesi: 63.6,
    bellekMb: 1024,
    acikPortlar: {
      "22/SSH",
      "443/HTTPS",
      "8883/MQTTS"
    },
    sslSertifikasiGecerliMi: true,

    // Özel exception'ın çalıştığını görebilmek için bu cihazı kapalı olarak oluşturdum.
    acikMi: false,
  );

  // List, aynı türden birden fazla veriyi sıralı şekilde bir arada tutmamızı sağlıyor.
  // Oluşturduğum bütün IoTCihaz nesnelerini aynı listede topladım.
  // Böylece where(), fold(), döngüler ve seri numarasıyla arama işlemlerini tek liste üzerinden yapabiliyorum.
  final List<IoTCihaz> devices = [
    multispektralSensor,
    edgeAiSunucusu,
    rtkGnssAlicisi,
    yaprakIslaklikSensoru,
    meteorolojiIstasyonu,
    loraWanGateway,
  ];

  // where(), listedeki elemanları kontrol edip sadece verdiğimiz şartı sağlayanları seçiyor.
  // Güvenlik açığı varsa veya CPU değeri %85'i geçtiyse cihazı riskli kabul ediyorum.
  // where() sonucu Iterable olduğu için sonunda toList() kullanarak sonucu List'e çeviriyorum.
  final riskliCihazlar = devices
      .where(
        (aygit) =>
            aygit.guvenlikAcigiVarMi ||
            aygit.cpuYukYuzdesi > 85
      )
      .toList();

  // fold(), listedeki değerlerden sonunda tek bir sonuç elde etmek için kullanılıyor.
  // Burada 0'dan başlayıp her cihazın bellekMb değerini mevcut toplama ekliyorum.
  // total o ana kadarki toplamı, device ise o anda işlem yapılan cihazı temsil ediyor.
  final int bellektotal = devices.fold(
    0,
    (total, device) =>
        total + device.bellekMb,
  );

  // print() ile yaptığım işlemlerin sonuçlarını konsolda gösteriyorum.
  // \n yeni satıra geçmemi sağladığı için çıktı bölümlerini birbirinden ayırmakta kullanıyorum.
  print("\n===== AKILLI TARLA IoT SISTEMI =====");

  print("\n--- Ağa Bağlı Cihazlar ---");

  // Ağdaki bütün cihazların temel bilgilerini sırayla ekrana yazdırıyorum.
  for (var device in devices) {

    // ${} kullanarak String içine değişken veya ifade sonucu ekleyebiliyorum.
    // .name ile enum değerinin sadece ad kısmını alıyorum.
    print(
      "${device.cihazAdi} | "
      "Seri No: ${device.seriNo} | "
      "Tip: ${device.tip.name} | "
      "CPU: %${device.cpuYukYuzdesi} | "
      "Bellek: ${device.bellekMb} MB"
    );
  }

  print("\n--- Risk Altındaki Cihazlar ---");

  // Daha önce where() ile ayırdığım riskli cihazları burada tek tek kontrol ediyorum.
  // Burada sadece cihaz adını değil, hangi sebeple riskli olduğunu da göstermeye çalışıyorum.
  for (var cihaz in riskliCihazlar) {

    // && "ve" anlamına geliyor ve iki şartın da aynı anda doğru olmasını istiyor.
    // Cihazda hem güvenlik açığı hem yüksek CPU varsa iki durumu birlikte yazdırıyorum.
    if (
      cihaz.guvenlikAcigiVarMi &&
      cihaz.cpuYukYuzdesi > 85
    ) {
      print(
        "${cihaz.cihazAdi} -> "
        "Güvenlik açığı ve yüksek CPU kullanımı"
      );
    }

    // İlk şart sağlanmadıysa cihazda sadece güvenlik açığı olup olmadığına bakıyorum.
    else if (cihaz.guvenlikAcigiVarMi) {
      print(
        "${cihaz.cihazAdi} -> "
        "Güvenlik açığı"
      );
    }

    // Güvenlik açığı yoksa ama CPU %85'in üzerindeyse risk sebebini yüksek CPU olarak yazdırıyorum.
    else if (cihaz.cpuYukYuzdesi > 85) {
      print(
        "${cihaz.cihazAdi} -> "
        "Yüksek CPU kullanımı"
      );
    }
  }

  print("\n--- Bellek Kullanım Miktarı ---");

  // fold() ile hesapladığım toplam bellek miktarını burada ekrana yazdırıyorum.
  print(
    "Ağdaki toplam bellek: "
    "$bellektotal MB"
  );

  print("\n--- Cihaz Sorgulaması ---");

  // Record yapısını göstermek için Edge AI cihazını seri numarası üzerinden sorguluyorum.
  final bilgi = cihazdanBilgiyiAl(
    devices,
    "AGRI-EDGE-001",
  );

  // Named Record kullandığım için dönen bilgilere alan isimleriyle ulaşabiliyorum.
  print(
    "Cihaz adı: ${bilgi.cihazAdi}"
  );

  print(
    "Cihaz tipi: ${bilgi.tip.name}"
  );

  print(
    "Alarm durumu: ${bilgi.alarmDurumu}"
  );

  print("\n--- İzolasyon Bölgeleri ---");

  // Bütün cihazları döngüyle gezip tiplerini Switch Expression kullanan metoda gönderiyorum.
  // Böylece her cihazın hangi izolasyon bölgesinde olduğunu görebiliyorum.
  for (var device in devices) {
    print(
      "${device.cihazAdi} -> "
      "${izolasyonBolgesi(device.tip)}"
    );
  }

  print("\n--- Cihazlara Erişim Kontrolü ---");

  // try, hata oluşma ihtimali olan kodu kontrollü şekilde çalıştırmak için kullanılıyor.
  // Burada özellikle kapalı olarak oluşturduğum cihazı sorgulayıp exception'ın çalışmasını test ediyorum.
  try {

    final kapaliCihaz = cihazdanBilgiyiAl(
      devices,
      "AGRI-LORA-001",
    );

    // Cihaz açık olsaydı fonksiyondan dönen Record burada ekrana yazdırılacaktı.
    print(kapaliCihaz);

  }

  // catch, try bloğunda oluşan hatayı yakalıyor.
  // e değişkeni yakalanan hatayı tuttuğu için hata mesajını programı kapatmadan ekrana yazdırabiliyorum.
  catch (e) {

    print(
      "Erişim sırasında hata oluştu: $e"
    );

  }

  print(
    "\n===== Sistem Kontrolleri Tamamlandı ====="
  );
}