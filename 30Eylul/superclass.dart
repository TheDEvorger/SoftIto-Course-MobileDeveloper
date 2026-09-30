//Üst sınıf açalım
class TemelSavasci{
  final String ad;
  final double temelGuc;

  TemelSavasci({
    required this.ad,
    required this.temelGuc,
  });

  void saldir(){
    print("[$ad] temel fiziksel yumruk attı. Hasar: $temelGuc");
  }


}
class MelekBuyucu extends TemelSavasci{
  int manaPuani;
  MelekBuyucu({required this.manaPuani, required super.ad, required super.temelGuc});
  @override
  void saldir(){
    if(manaPuani>=10){
      manaPuani -=10;
      print("[$ad] Alev topu fırlattı: hasar: ${temelGuc * 2} kalan mana: $manaPuani");
    } else{
      print("Mana Tükendi");
      super.saldir();
    }
  }
}

class Okcu extends TemelSavasci{
  int okSayisi;
  Okcu({
    required this.okSayisi,
    required super.ad,
    required super.temelGuc
  });
  void saldir(){
    if(okSayisi>0){
      okSayisi--;
      print("[$ad] hedefe zehirli ok fırlattı: hasar: ${temelGuc * 1.5} kalan ok sayısı: $okSayisi");
    }
    else{
      print("Ok Bitti");
      super.saldir();
    }
  }
}

void main(){
  print("Savaş Arenası");
  final asker=TemelSavasci(ad: "Ayberk", temelGuc: 20.0);
  //yumruk atar
  final merlin=MelekBuyucu(manaPuani: 20, ad: "Sümeyye", temelGuc: 40);
  merlin.saldir();
  final legolas = Okcu(okSayisi: 5, ad: "Zelal", temelGuc: 35.0);
  legolas.saldir();
  print("Kazanan MELEK BÜYÜCÜ 🏆, iyiliğin gücü adına.")
}