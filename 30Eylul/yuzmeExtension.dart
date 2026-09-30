class Denizci {
  final String oyuncuAdi;

  Denizci({required this.oyuncuAdi});
}

extension YuzmeYetisi on Denizci {
  void dalisYap() {
    print("su altına dal");
  }
}

void main() {
  final ustaDenizci = Denizci(oyuncuAdi: "Denizlerin Kaşifi Selahaddin Çiftçi");
  
  print("${ustaDenizci.oyuncuAdi} için yetenek kullanılıyor:");
  ustaDenizci.dalisYap(); 
}