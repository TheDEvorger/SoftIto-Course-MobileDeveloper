/*

Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

    print("Tüm veriler geldi $result");
  } catch (e) {
    print("isteklerden Biri başarısız oldu $e");
  }
}

*/

//Future:Tek bşr kere verş çekileceği zaman kullanılır ya da hata yada değer döndürüp bitirir.
//Stream:Bir boru hattı şeklinde çalışır (pipe), Zaman içinde 1 10 100 ya da sonsuz sayıda veri sağlanabilir.
//(Borsa fiyatları GPS konum güncelleme,Firebase canlı dinleme)

import 'dart:async';

void main() {
  //controller oluşturma
  final controller = StreamController<int>();
  //dinleyici (listener) bağlama
  final subscription = controller.steam.listen(
    (data) => print("yeni Veri: $data"),
    onError: (err) => print("Hata Oluştu: $err"),
    onDone: () => print("yayın Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI Ekranı: $d"));
  broadcastStream.listen((d) => print("Analitik Servisi Ekranı: $d"));

  controller.close();
}
