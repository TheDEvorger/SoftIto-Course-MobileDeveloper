//mixin and with

mixin UcmaYetisi{
  int ucusIrtifasiMetre=100;
  void gogeYuksel(){
    print("Uçuş Yetisi: Kanatlarını açtı ve $ucusIrtifasiMetre metreye yükseldi");
  }
}

mixin GorunmezlikYetisi{
  void pelerinOrt(){
    print("Görünmezlik: düşmanların gözünden tamamen kayboldu!");
  }
}

mixin AtesGucuYetisi{
  void alevSaldirisi(){
    print("Ateş Gücü: Kılıcını alevlendirdi ve alanı yaktı.");
  }
}

class TemelKarakter{
  final String ad;
  TemelKarakter({required this.ad});
}

class EfsaneviEjderBinicisi extends TemelKarakter with UcmaYetisi, AtesGucuYetisi{
  final String ejderhaAdi;
  EfsaneviEjderBinicisi({required this.ejderhaAdi, required super.ad});

  void hucumEt(){
    print("$ad ve ejderhası $ejderhaAdi savaşa atılıyor");
    gogeYuksel();
    alevSaldirisi();
  }
}

class GolgeSuikastcisi extends TemelKarakter with GorunmezlikYetisi{
  GolgeSuikastcisi({required super.ad});

  void suikastYap(){
    print("$ad hedefe sessizce yaklaşıyor");
    pelerinOrt();
    print("kritik darbe vurdu");

  }
}

void main(){
  print("Süper güçler başlatılıyor");
  final birinci=EfsaneviEjderBinicisi(ejderhaAdi: "Aslıhan", ad: "Gencer");
  birinci.hucumEt();
  final ikinci=GolgeSuikastcisi(ad: "Adil Murat");
  ikinci.suikastYap();
}