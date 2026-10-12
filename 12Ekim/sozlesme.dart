/*
// Soyutlama Abstraction Kavramı

//1. Adım (sözleşmeler) Contract
abstract class AutReposity{
  Future<String>login(String email,String password);
  Future<void>logout();
  bool get isAuth;
}

class FirebaseAuthRepository implements AutReposity{
  @override
  Future<String> login(String email, String password) async {
    //gerçek Firebas SDK Çaprısı
    return "firebase_token_xyz_123";
  }

  @override
  Future<void> logout() async {
    // Firebase logout
  }

  @override
  bool get isAuth => true;
  }

  // Test ve offline simülasyon
class MockAuthReposity implements AutReposity {
  @override
  Future<String> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    return "mock_token_abc_789";
  }

  @override
  Future<void> logout() async {}

  @override
  bool get isAuth => false;
}
 

 mixin logger {
  void log(String msg)=>print("LOG:$msg")
 }

 mixin Analytics{
  void log(String msg)
 }

 class PaymentService with logger, Analytics{
  void pay() {
    log("Ödeme Yapıldı");
  }
 }

 abstract class BaseWidget{}
 // sadece BaseWideger ve alt sınırflarda kullanılabilir.

 mixin LifeLogger on BaseWidget{
  void logInit() => print("Widget Başlatıldı");
 }

*/

//__________________________________________________________________

/*
extension StringValidator on String{
  bool get isValidEmail {
    final emailRegex = RegExpRegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  String toCapitalize(){
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}


//Kullanımı
void main(){
  String email="selahaddin@kodvance.com";
  if(email.isValidEmail){
    print("Geçerli Eposta");
  }
  else{
    print("Geçersiz Eposta");
  }
}
*/

//__________________________________________________________________

/*
abstract class Identifiable {
  String get id;
}

// T tipi Mutlafa Identifiable arayüzübü uygulamak ZORUNDADIR
class GenericCache<T extends Identifiable> {
  final Map<String, T> _storage = {};

  void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındı");
  }

  T? getById(String id) => _storage[id];
}
*/

//__________________________________________________________________

import 'dart:async';

void main() {
  print("1.Senkron başladı");
  scheduleMicrotask(() {
    print("2.Task Oluştu(Vip Kuyruk)");
  });
  Future(() {
    print("3.Standart Event Kuyruğu");
  });
  Future.microtask(() {
    print("4.Future.microtask çalıştı");
  });

  print("5.Senkron kod tamamlandı");
}

//Future veri tipinden bağımısz çalıştırır.
//İşlem başladımı devammı ediyor bittimi bunun
//bilgisinide paylaşır
