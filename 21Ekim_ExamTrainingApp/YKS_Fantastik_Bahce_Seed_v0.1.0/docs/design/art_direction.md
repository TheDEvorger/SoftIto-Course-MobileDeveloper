# İllüstrasyon Sanat Yönetimi | 10 ayrı özgün sahne

**Sahne referansları:** `../../design/source_art/` (PNG master), `../../assets/illustrations/scenes/` (uygulama WebP). Tek bir kolaj dosyasından crop alınmayacak. Her görsel bir asset.

- Hafif anime esintili, özgün çevre resimleme, nitelikli güneş ışığı / fener ışığı, zengin yeşil, turkuaz su, altın sarısı vurgular, mor gece.
- Pastel ağırlıklı / flulaştırılmış tüm ekran değil. Göz alıcı doğa ile işlevsel kart yüzeylerini dengele.
- Kimliği bilinen bir animasyon stüdyosunun veya spesifik yaşayan sanatçının stilini birebir kopyalama.
- Dış kütüphaneye indirme bağımlılığı olmadan uygulama paketinden yükle; çevrimdışı çalışır.
- WebP'ler kalite odaklı sıkıştırma kopyalarıdır; yeni varyasyon istenirse PNG masterdan türet.
- 941×1672 dikey görsel; her cihazda tek kesim uygun olmaz. Uygun `alignment`, odak noktası / boyut sınırı kullan; kritik metin görsele gömülü değil.
- `Image.asset` için cache, `fit`, semanticLabel veya dekoratif ise excludeFromSemantics; yüksek bellek yükü oluşturacak hero tam ekran resimlerini geciktir.
- İlk sürümde animasyon zorunlu değil. Hareket katmanları eklenecekse çok küçük, pil dostu ve isteğe bağlı.
- Orijinal kaynakları salt okunur üretim varlığı gibi ele al; değişiklikleri kopya olarak yap.

## Sahne seçenekleri

Ayrıntılı eşleme ve SHA-256: `../../assets/illustrations/asset_manifest.json`.

| Sahne | Ana kullanım |
| --- | --- |
| 01 Sabah kır evi | Ana sayfa üst alan / karşılama |
| 02 Orman nehri | Günlük plan |
| 03 Fenerli açıklık | Başarı veya odak hazırlığı |
| 04 Botanik kış bahçesi | Konular / öğrenme |
| 05 Dağ vadisi | Hedef / ilerleme |
| 06 Ay ışığı bahçesi | Koyu tema |
| 07 Altın saat terası | Profil / motivasyon |
| 08 Zümrüt şelaleler | Konu haritası |
| 09 Orman çalışma kulübesi | Pomodoro / odak |
| 10 Yağmur sonrası bahçe | Günlük başarı |
