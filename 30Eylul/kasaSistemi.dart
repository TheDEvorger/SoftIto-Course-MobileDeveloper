class KasaSistemi {
  final String _oyuncuAdi; 
  double _altinBakiye = 0.0; 

  KasaSistemi({required String oyuncuAdi}) : _oyuncuAdi = oyuncuAdi;

  String get oyuncuAdi {
    return _oyuncuAdi;
  }

  double get altinBakiye {
    return _altinBakiye;
  }

  set altinEkle(double gelenAltin) {
    if (gelenAltin < 0.0) {
      print("Sahte altın! Altın verilemez."); 
    } else {
      _altinBakiye += gelenAltin; 
    }
  }

  bool get kasadaAltinVarMi {
    return _altinBakiye > 0.0;
  }
  
}

void main() {
  print("Kasa Güvenlik Sistemi");
  
  final oyuncuKasasi = KasaSistemi(oyuncuAdi: "Selahaddin Çiftçi");
  
  print("Oyuncu: ${oyuncuKasasi.oyuncuAdi}");
  print("Başlangıç Bakiye: ${oyuncuKasasi.altinBakiye} Altın");
  
  print("Kasaya 150 altın eklendi");
  oyuncuKasasi.altinEkle = 50.0; 
  print("Güncel Bakiye: ${oyuncuKasasi.altinBakiye} Altın");
  
  print("Hile yapılmaya çalışıldı, eksi (-50) bakiye gönderildi");
  oyuncuKasasi.altinEkle = -50.0; 
  
  print("Nihai Bakiye: ${oyuncuKasasi.altinBakiye} Altın");
  print("Kasada Altın Var mı? ${oyuncuKasasi.kasadaAltinVarMi ? 'Evet' : 'Hayır (Kasa Boş)'}");
}