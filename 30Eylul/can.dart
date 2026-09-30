class CanSistemi{
  final String karakterAdi;
  double _canPuani=100.0;//başındaki _ çizgi bu değişkeni gizli olarak kodlar

  CanSistemi({required this.karakterAdi});

  // getter ile can puanı güvenli dışarıya okutma
  double get canPuani{
    return _canPuani;
  }

  // setter ile can değeri değişirken oyun kurallarını denetleyelim

  set canPuani (double yeniCan){
    if(yeniCan <= 0.0){
      _canPuani=0.0;
      print("$karakterAdi canı tükendi ve yere yığıldı");
    }
    else if(yeniCan>100){
      _canPuani=100.0;
      print("can tamamen dolu, can maksimum 100 puan olabilir.");
    }
    else{
      _canPuani=yeniCan;
    }
  }

  bool get hayattaMi{
    return _canPuani >0.0;
  }
}

void main(){
  print("Can Barı Güvenlik Sistemi");
  final savasciCani=CanSistemi(karakterAdi: "Meltem Demir");
  print("Başlangıç Güç: HP ${savasciCani.canPuani}");
  print("35 hasar alındı");
  savasciCani.canPuani =65;
  print("Kalan can : HP ${savasciCani.canPuani}");
  print("200 can veren iksir içildi");
  savasciCani.canPuani=200.0;
  print("Sabitlenen can: HP ${savasciCani.canPuani}");
  print("Ölümcül darbe aldı");
  savasciCani.canPuani=-50.0;
  print("Nihai can: HP ${savasciCani.canPuani}");
  print("Savaşçı Hayatta mı? ${savasciCani.hayattaMi ? 'Evet':'Hayır (Öldü)'}");

}