abstract class LoncaUyesi{
  final String rumuz;
  LoncaUyesi({
    required this.rumuz,
  });

  // Soyut metot abstract method
  void ozelyetenekKullan();
  void loncaSelamVer(){
    print("$rumuz Lonca Bayrağını selamladı: `onur ve zafer için`");
  }
}

class Sovalye extends LoncaUyesi{
  Sovalye ({
    required super.rumuz
  });
  @override
  void ozelyetenekKullan(){
    print("$rumuz Demir kalkanını kaldırdı ve savunma duvarı ördü");
  }
}

class Sifaci extends LoncaUyesi{
  Sifaci ({
    required super.rumuz
  });
  @override
  void ozelyetenekKullan(){
    print("$rumuz Kutsal ışık büyüsüyle tüm takımın canını tazeledi");
  }

}

void savasAlanindaKomutVer(List<LoncaUyesi>takim){
  print("liderin emriyle takım yetenekleri devreye girsin");
  for(var t in takim){
    t.loncaSelamVer();
    //herkes kendi özel yeteneğiyle selam versin
    t.ozelyetenekKullan();
  }
}

void main(){
  print("Lonca Takımı");
  final List<LoncaUyesi> loncaBirligi=[
    Sovalye(rumuz: "Kızıl Şövalye Adil"),
    Sifaci(rumuz: "Orman perisi Shahd"),
    Sovalye(rumuz: "Gümüş Muhafız Eren"),
  ];

  //Hepsine tek bir emir ile çalıştırıyoruz
  savasAlanindaKomutVer(loncaBirligi);
}
