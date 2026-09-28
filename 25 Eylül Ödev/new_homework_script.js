// Başlangıçta elimizde bulunacak siparişleri orders dizisinin içinde tutuyoruz.
// Daha sonra silme işleminde bu diziye tekrar değer atayacağımız için const yerine let kullandık.
let orders = [

    // İlk ürünümüz Sehpa; id, isim, kategori ve fiyat bilgilerini aynı object içinde topladık.
    { id: 1, name: "Sehpa", category: "Mobilya", price: 6500 },

    // Abajürü Aydınlatma kategorisiyle beraber başlangıç listesine ekledik.
    { id: 2, name: "Abajür", category: "Aydınlatma", price: 7500 },

    // Koltuk ürününü Mobilya kategorisinde ve 8500 fiyatıyla tanımladık.
    { id: 3, name: "Koltuk", category: "Mobilya", price: 8500 },

    // Bulaşık makinasını Mutfak kategorisine ait başka bir sipariş olarak ekliyoruz.
    { id: 4, name: "Bulaşık Makinası", category: "Mutfak", price: 10000 },

    // Başlangıç listesindeki son ürünümüz Ocak.
    { id: 5, name: "Ocak", category: "Mutfak", price: 15000 }

// Başlangıçta kullanacağımız orders dizisi burada tamamlanıyor.
];


// HTML tarafında daha sonra sık sık kullanacağımız elemanları baştan değişkenlere alıyoruz.

// Sipariş kartlarının JavaScript tarafından ekleneceği ana liste alanını seçiyoruz.
const orderContainer = document.getElementById("orderContainer");

// Yeni ürün eklemek için kullandığımız formu id üzerinden buluyoruz.
const orderForm = document.getElementById("orderForm");

// Ürün adına göre arama yapılan input alanını seçtik.
const searchInput = document.getElementById("searchInput");

// Sağ taraftaki kategori filtresine buradan ulaşacağız.
const categoryFilter = document.getElementById("categoryFilter");

// Kayıtlı sipariş sayısını göstereceğimiz KPI alanını seçiyoruz.
const kpiCount = document.getElementById("kpiCount");

// Toplam sipariş tutarının yazılacağı alanı değişkene aldık.
const kpiTotal = document.getElementById("kpiTotal");

// Ortalama ürün fiyatını göstereceğimiz KPI alanı.
const kpiAvg = document.getElementById("kpiAvg");

// Formdaki ürün adı inputuna JavaScript tarafından ulaşmak için bu değişkeni kullanacağız.
const prodName = document.getElementById("prodName");

// Formda seçilen ürün kategorisini buradan okuyacağız.
const prodCat = document.getElementById("prodCat");

// Kullanıcının girdiği fiyat değerine ulaşacağımız input alanı.
const prodPrice = document.getElementById("prodPrice");


// Bu fonksiyon kendisine verilen listeye bakıp üst taraftaki üç KPI bilgisini güncelliyor.
const updateKPIs = (dataList) => {

    // Dizinin length değeri bize kaç ürün olduğunu verdiği için sipariş sayısını direkt buraya yazıyoruz.
    kpiCount.textContent = dataList.length;

    // Eğer elimizde hiç ürün kalmadıysa toplam ve ortalama hesabını ayrıca yapmaya gerek yok.
    if (dataList.length === 0) {

        // Liste boşken toplam tutarın eski değerde kalmaması için 0 ₺ yapıyoruz.
        kpiTotal.textContent = "0 ₺";

        // Ürün olmadığı durumda ortalama fiyatı da sıfırlıyoruz.
        kpiAvg.textContent = "0 ₺";

        // Boş liste durumu halledildiği için fonksiyonun aşağısına devam etmiyoruz.
        return;

    // Boş liste kontrolünün olduğu if bloğu burada bitiyor.
    }

    // reduce ile ürünlerin price değerlerini sırayla topluyoruz.
    // acc o ana kadar biriken toplamı, curr ise sıradaki ürünü temsil ediyor.
    const total = dataList.reduce((acc, curr) => acc + curr.price, 0);

    // Hesaplanan toplamı 47500 yerine 47.500 şeklinde göstermek için Türkçe sayı formatını kullanıyoruz.
    kpiTotal.textContent = `${total.toLocaleString("tr-TR")} ₺`;

    // Ortalama fiyatı bulmak için toplam tutarı listedeki ürün sayısına bölüyoruz.
    const avg = total / dataList.length;

    // Ortalama küsuratlı çıkarsa yuvarlayıp yine Türkçe sayı biçiminde ekrana yazdırıyoruz.
    kpiAvg.textContent = `${Math.round(avg).toLocaleString("tr-TR")} ₺`;

// KPI hesaplarını yapan fonksiyon burada sona eriyor.
};


// Siparişleri filtreleyip ekrana basacağımız ana fonksiyonumuz.
// Arama, kategori değişikliği, ekleme veya silme olduğunda listeyi bununla tekrar oluşturacağız.
const renderOrders = () => {

    // Arama kutusuna yazılan değeri alıyoruz.
    // Küçük harfe çevirerek Sehpa ile sehpa gibi yazımları aynı kabul ediyoruz, trim de gereksiz boşlukları temizliyor.
    const term = searchInput.value.toLowerCase().trim();

    // Kullanıcının kategori filtresinde hangi seçeneği seçtiğini alıyoruz.
    const selectedCat = categoryFilter.value;

    // orders dizisindeki ürünleri arama ve kategori şartına göre süzüyoruz.
    const filtered = orders.filter((order) => {

        // Ürün adının içinde kullanıcının yazdığı kelime geçiyor mu diye kontrol ediyoruz.
        const matchesName = order.name.toLowerCase().includes(term);

        // ALL seçiliyse bütün kategorilere izin veriyoruz.
        // Başka bir kategori seçilmişse ürünün kategorisinin onunla aynı olması gerekiyor.
        const matchesCategory = selectedCat === "ALL" || order.category === selectedCat;

        // İsim ve kategori şartlarının ikisi de doğruysa bu ürün filtered dizisinde kalıyor.
        return matchesName && matchesCategory;

    // filter işleminin callback kısmını burada tamamlıyoruz.
    });

    // Listeyi yeniden oluşturacağımız için önce önceki kartları temizliyoruz.
    // Bunu yapmazsak her render işleminde aynı ürünler tekrar aşağıya eklenir.
    orderContainer.innerHTML = "";

    // Filtre sonucunda hiçbir ürün bulunamadıysa kullanıcıya boş bir alan göstermek istemiyoruz.
    if (filtered.length === 0) {

        // Ürün bulunamadı mesajı için yeni bir div oluşturuyoruz.
        const emptyMessage = document.createElement("div");

        // CSS'teki empty-state görünümünü bu div üzerine uyguluyoruz.
        emptyMessage.className = "empty-state";

        // Kullanıcıya neden liste göremediğini belirten mesajı yazıyoruz.
        emptyMessage.textContent = "Kriterlere Uygun Ürün Bulunamadı";

        // Hazırladığımız mesajı sipariş listesinin bulunduğu alana ekliyoruz.
        orderContainer.appendChild(emptyMessage);

        // Görünen ürün kalmadığı için KPI değerlerini de boş listeye göre sıfırlıyoruz.
        updateKPIs([]);

        // Aşağıdaki kart oluşturma kısmına girmeden fonksiyonu burada bitiriyoruz.
        return;

    // Ürün bulunamaması durumunu kontrol ettiğimiz bölüm burada kapanıyor.
    }

    // Filtreyi geçen her ürün için ayrı ayrı bir sipariş kartı oluşturuyoruz.
    filtered.forEach((order) => {

        // Her siparişin dış kısmını oluşturacak article elementini hazırlıyoruz.
        const item = document.createElement("article");

        // Bu karta CSS tarafındaki order-item görünümünü veriyoruz.
        item.className = "order-item";

        // Kartın sol tarafında ürün adı ve fiyat bilgisini tutacak divi oluşturduk.
        const infoBox = document.createElement("div");

        // Ürün adını göstermek için h5 elementi hazırlıyoruz.
        const title = document.createElement("h5");

        // Hangi ürün üzerinde çalışıyorsak onun adını başlığa yazıyoruz.
        title.textContent = order.name;

        // Fiyat bilgisini ayrı göstermek için bir p elementi oluşturuyoruz.
        const priceText = document.createElement("p");

        // Ürünün fiyatını binlik ayraçlı şekilde kartın içine yazdırıyoruz.
        priceText.textContent = `Birim Fiyat: ${order.price.toLocaleString("tr-TR")} ₺`;

        // Önce ürün başlığını bilgi kutusunun içine ekliyoruz.
        infoBox.appendChild(title);

        // Fiyat bilgisini de ürün adının bulunduğu aynı kutuya dahil ediyoruz.
        infoBox.appendChild(priceText);

        // Kartın sağında kategori etiketiyle Sil butonunun bulunacağı alanı oluşturuyoruz.
        const metaBox = document.createElement("div");

        // Sağ tarafın düzenini CSS'teki meta-box class'ından alıyoruz.
        metaBox.className = "meta-box";

        // Kategori adını göstermek için küçük bir span oluşturduk.
        const badge = document.createElement("span");

        // Ürünün kategorisine göre hangi renk class'ının kullanılacağını burada seçiyoruz.
        const badgeClass = order.category === "Mobilya"

            // Ürün Mobilya kategorisindeyse mobilyaya ait badge class'ını kullanıyoruz.
            ? "badge--mobilya"

            // Mobilya değilse bu sefer Aydınlatma olup olmadığını kontrol ediyoruz.
            : order.category === "Aydınlatma"

                // Aydınlatma ise ona ait class seçiliyor.
                ? "badge--aydinlatma"

                // Diğer durumda elimizde kalan kategori Mutfak olduğu için mutfak class'ını veriyoruz.
                : "badge--mutfak";

        // Badge'in ortak stilini ve kategoriye özel rengini aynı anda bağlıyoruz.
        badge.className = `badge ${badgeClass}`;

        // Rozetin içinde de ürünün gerçek kategori adını gösteriyoruz.
        badge.textContent = order.category;

        // Her sipariş kartının kendine ait Sil butonunu oluşturuyoruz.
        const deleteButton = document.createElement("button");

        // Bunun normal bir buton olduğunu belirtiyoruz; herhangi bir formu submit etmesini istemiyoruz.
        deleteButton.type = "button";

        // Sil butonunun görünümünü CSS'teki btn-del class'ından alıyoruz.
        deleteButton.className = "btn-del";

        // Kullanıcının buton üzerinde göreceği yazıyı belirledik.
        deleteButton.textContent = "Sil";

        // Kullanıcı bu butona tıkladığında ilgili siparişi listeden kaldıracağız.
        deleteButton.addEventListener("click", () => {

            // filter ile silmek istediğimiz ürünün id'si dışındaki bütün kayıtları tutuyoruz.
            // Böylece eşleşen ürün yeni orders dizisinin dışında kalmış oluyor.
            orders = orders.filter((currentOrder) => currentOrder.id !== order.id);

            // Veri değiştiği için kartları ve KPI değerlerini yeniden oluşturuyoruz.
            renderOrders();

        // Sil butonunun click eventi burada tamamlanıyor.
        });

        // Kategori rozetini kartın sağ tarafındaki alana ekliyoruz.
        metaBox.appendChild(badge);

        // Sil butonu da rozetin yanındaki yerini alıyor.
        metaBox.appendChild(deleteButton);

        // Ürün adı ve fiyatın bulunduğu sol bölümü kartın içine koyuyoruz.
        item.appendChild(infoBox);

        // Kategori ve Sil butonunun bulunduğu sağ kısmı da karta ekliyoruz.
        item.appendChild(metaBox);

        // Kart artık tamamlandı, sipariş listesinin içine ekleyip ekranda gösteriyoruz.
        orderContainer.appendChild(item);

    // filtered dizisindeki bütün ürünler için kart oluşturma işlemi burada bitiyor.
    });

    // Son olarak KPI değerlerini ekranda gerçekten görünen filtered listesine göre güncelliyoruz.
    updateKPIs(filtered);

// Siparişleri ekrana basan renderOrders fonksiyonunun sonu.
};


// Kullanıcı formu gönderdiğinde yeni sipariş oluşturma işlemlerini burada yapıyoruz.
orderForm.addEventListener("submit", (event) => {

    // Formun normal davranışı sayfayı yenileyebileceği için bunu engelliyoruz.
    event.preventDefault();

    // Ürün adı inputundaki yazıyı alıp baş ve sondaki gereksiz boşlukları temizliyoruz.
    const name = prodName.value.trim();

    // Kullanıcının seçtiği kategori değerini alıyoruz.
    const category = prodCat.value;

    // Input değerleri metin olarak geldiği için fiyatı Number kullanarak sayıya çeviriyoruz.
    const price = Number(prodPrice.value);

    // İsim boşsa, fiyat sayı değilse veya 100'den küçükse bu kaydı kabul etmiyoruz.
    if (name === "" || Number.isNaN(price) || price < 100) {

        // Kullanıcıya girişte neyin yanlış olduğunu kısa bir uyarıyla bildiriyoruz.
        alert("Lütfen geçerli bir ürün adı ve en az 100 TL fiyat girin.");

        // Hatalı bilgilerle ürün oluşturmamak için işlemi burada kesiyoruz.
        return;

    // Form kontrolü için açtığımız if bloğu burada kapanıyor.
    }

    // Kontrollerden geçen bilgilerle yeni ürün objectini hazırlıyoruz.
    const newOrder = {

        // Her yeni ürüne farklı bir id verebilmek için o anki zamanı kullanıyoruz.
        id: Date.now(),

        // Inputtan aldığımız ürün adını objectin name alanına yazıyoruz.
        name: name,

        // Seçilen kategori yeni ürünün category bilgisi oluyor.
        category: category,

        // Sayıya çevirdiğimiz fiyatı da price alanında saklıyoruz.
        price: price

    // Yeni sipariş objectini burada tamamlıyoruz.
    };

    // Oluşturduğumuz ürünü orders dizisinin sonuna ekliyoruz.
    orders.push(newOrder);

    // Kayıt bittikten sonra formu başlangıç haline döndürüyoruz.
    orderForm.reset();

    // Yeni eklenen ürünün hemen görünmesi için listeyi tekrar oluşturuyoruz.
    renderOrders();

// Formun submit eventi burada bitiyor.
});


// Kullanıcı arama kutusunda her değişiklik yaptığında listeyi yeniden filtreliyoruz.
searchInput.addEventListener("input", renderOrders);

// Kategori seçimi değiştirildiğinde de aynı render fonksiyonunu tekrar çalıştırıyoruz.
categoryFilter.addEventListener("change", renderOrders);

// Sayfa ilk açıldığında henüz herhangi bir event gerçekleşmediği için başlangıç listesini bir kere kendimiz oluşturuyoruz.
renderOrders();