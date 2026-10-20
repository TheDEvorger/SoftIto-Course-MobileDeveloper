# Güvenlik ve veri sınırları
Bu paket yalnızca yerel prototip. Veriler cihazdaki SQLite dosyasındadır.
SQLite şifreli değildir; gerçek hassas müşteri verisiyle test yapmayın.
Sunucu hesabı, topluluk akışı, e-posta daveti veya ödeme entegrasyonu yok.

Antigravity Agent için:
- Secrets veya tokenları sohbet/commit/loglara yazma.
- Ücretli API, internet servis hesabı, yayınlama için açık onay.
- `flutter create --overwrite`, dosya silme veya destructive migration yok.
- Network için server-side auth ve moderation gelmeden gerçek kullanıcı yok.
- Veri yedekleme ve saklama politikası geliştirme görevlerinde var.
