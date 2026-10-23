# HægæRûetn — GroqCloud & Cloudflare Worker Kurulum Kılavuzu

Bu belge, HægæRûetn krallığının **Bilge Rehber** yapay zekâ sisteminin GroqCloud ve Cloudflare Worker Free katmanı ile güvenli, sıfır maliyetli ve kesintisiz entegrasyon adımlarını açıklar.

---

## 1. Mimariye Genel Bakış

```
+---------------------------+             HTTPS             +---------------------------------------+
|  Flutter İstemcisi        | ---------------------------> |  Cloudflare Worker Free               |
|  (HægæRûetn Mobil / Web)  |                              |  - Rate Limiting (15/dk, 120/gün)     |
|  - API anahtarı barındırmaz| <--------------------------- |  - Request Sanitization (max 32KB)    |
|  - Sadece Worker URL bilir |             JSON             |  - Secret: GROQ_API_KEY              |
+---------------------------+                              +---------------------------------------+
                                                                               |
                                                                               | HTTPS (OpenAI API)
                                                                               v
                                                           +---------------------------------------+
                                                           |  GroqCloud LPU Inference Engine       |
                                                           |  - Model 1: qwen/qwen3.8-27b (Öncelik) |
                                                           |  - Model 2: openai/gpt-oss-20b        |
                                                           +---------------------------------------+
```

---

## 2. Model Seçimi ve Kotası

* **Öncelikli Model:** `qwen/qwen3.8-27b`
  * Yüksek hız, üstün Türkçe anlama, bağlam takibi ve yapılandırılmış JSON çıktısı (ahit önerileri) üretme yeteneği.
* **Alternatif Model:** `openai/gpt-oss-20b`
  * Yüksek hız (~1.000 token/sn), hafif mimari ve sıfır maliyetli kota tasarrufu.
* **Maliyet Politikası:** Sıfır maliyet. GroqCloud ve Cloudflare Workers ücretsiz paket sınırları içinde kalınır. Asla otomatik ücretli plana geçilmez.

---

## 3. Adım Adım Kurulum

### Adım 1: GroqCloud API Anahtarı Edinme

1. [https://console.groq.com](https://console.groq.com) adresine gidin ve ücretsiz bir hesap açın.
2. Sol menüden **API Keys** sekmesine tıklayın.
3. **Create API Key** butonuna basın ve anahtarınıza bir isim verin (örn: `haegaruuetn-ai`).
4. Üretilen anahtarı kopyalayın (`gsk_...` ile başlar).
5. **ÖNEMLİ:** Bu anahtarı asla Flutter koduna, GitHub deposuna veya istemci dosyalarına yazmayın!

---

### Adım 2: Cloudflare Worker Kurulumu & Yayınlama

Projede hazır bulunan Worker dosyaları `server/cloudflare-worker/` dizinindedir:
* `worker.js`: Güvenli proxy, CORS, kota denetimi ve model çağrı mantığı.
* `wrangler.toml`: Cloudflare yapılandırması.
* `package.json`: Bağımlılıklar.

#### 1. Wrangler CLI ile Giriş Yapın
Terminalden Worker dizinine geçin:
```bash
cd server/cloudflare-worker
npx wrangler login
```

#### 2. Groq Secret'ını Tanımlayın
API anahtarını Cloudflare Worker'a şifreli bir environment secret olarak ekleyin:
```bash
npx wrangler secret put GROQ_API_KEY
```
*(Komut sizden kopyaladığınız `gsk_...` anahtarını yapıştırmanızı isteyecektir).*

#### 3. İsteğe Bağlı: İstemci Doğrulama Secret'ı
Worker'ı yalnızca kendi uygulamanızın kullanmasını istiyorsanız `CLIENT_SECRET` tanımlayabilirsiniz:
```bash
npx wrangler secret put CLIENT_SECRET
```

#### 4. Worker'ı Canlıya Yayınlayın
```bash
npx wrangler deploy
```
Komut başarıyla tamamlandığında size şu formatta bir URL verecektir:
```
https://haegaruuetn-ai-proxy.<hesap-adiniz>.workers.dev
```

---

### Adım 3: Worker URL'sini Flutter Uygulamasına Tanımlama

1. HægæRûetn uygulamasını çalıştırın (`flutter run` veya Xcode/Android).
2. Alt menüden 4. sekme olan **Rehber** ekranına gelin.
3. Üst durum çubuğundaki **Ayar simgesine (Ayarlar / Çark)** dokunun.
4. Açılan panodaki **Cloudflare Worker URL** kutusuna canlı Worker URL'nizi yapıştırın:
   ```
   https://haegaruuetn-ai-proxy.<hesap-adiniz>.workers.dev
   ```
5. **Kaydet** butonuna basın.
6. Durum çubuğunda yeşil onay işaretiyle `Bulut AI Aktif • qwen/qwen3.8-27b` ibaresini göreceksiniz.

*(URL tanımlanmadığı durumlarda uygulama otomatik olarak **Çevrimdışı Prototip** moduna geçer ve internetsiz de güvenle çalışır).*

---

## 4. Güvenlik & Gizlilik İlkeleri

1. **İstemcide Sıfır Secret:** `GROQ_API_KEY` kesinlikle derlenen mobil paket (.ipa / .apk) içinde yer almaz.
2. **Kullanıcı İzni Olmadan Veri Paylaşılmaz:** Alışkanlık özetleri yalnızca kullanıcı ayarlardan **"Alışkanlık Bağlamını Paylaş"** seçeneğini açtığında ve yalnızca kısa özet olarak gönderilir.
3. **Kullanıcı Onayı Olmadan Ahit İmzalanmaz:** Model bir ahit önerisi hazırladığında (`pact_suggestion`), kullanıcı ekrandaki **[Bu Ahdi İmzala]** butonuna basmadıkça hiçbir veri tabanı işlemi yapılamaz.
4. **Hafızasız Proxy:** Cloudflare Worker gelen mesajları veya yanıtları loglamaz ve hiçbir veri tabanında saklamaz.
5. **Dahili Hız & Kota Koruması:** IP başına dakikada en fazla 15, günde en fazla 120 istek sınırı uygulanarak ücretsiz Groq hesabının tükenmesi engellenir.

---

## 5. Yerel Test & Simülasyon

Worker'ı yerel makinenizde test etmek için:
```bash
cd server/cloudflare-worker
npx wrangler dev
```
Yerel Worker adresini (`http://localhost:8787`) test edebilirsiniz:
```bash
curl -X POST http://localhost:8787 \
  -H "Content-Type: application/json" \
  -H "X-App-Id: haegaruuetn-v1" \
  -d '{"messages": [{"role": "user", "content": "Merhaba!"}]}'
```
