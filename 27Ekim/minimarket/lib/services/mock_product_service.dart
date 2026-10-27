import '../models/product.dart';
import '../models/category.dart';
import 'product_services.dart';

class MockProductService implements ProductService {
    final List<Urun> _productstock=const[
        Urun(
            id:"1",
            name: "Iphone 16",
            price: 60000,
            description: "Apple'ın en yeni modeli",
            imageUrl: "https://cdn.akakce.com/iphone/apple-iphone-16-pro-max-256-gb-uzay-siyah-z.jpg",
            category: Category.elektronik,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"2",
            name: "Samsung Galaxy S26",
            price: 55000,
            description: "Samsung'un en yeni modeli",
            imageUrl: "https://cdn.akakce.com/iphone/apple-iphone-16-pro-max-256-gb-uzay-siyah-z.jpg",
            category: Category.elektronik,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"3",
            name: "Xiaomi Mi 15",
            price: 50000,
            description: "Xiaomi'nin en yeni modeli",
            imageUrl: "https://cdn.akakce.com/iphone/apple-iphone-16-pro-max-256-gb-uzay-siyah-z.jpg",
            category: Category.elektronik,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"4",
            name: "Oppo Find X8",
            price: 45000,
            description: "Oppo'nun en yeni modeli",
            imageUrl: "https://cdn.akakce.com/iphone/apple-iphone-16-pro-max-256-gb-uzay-siyah-z.jpg",
            category: Category.elektronik,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"5",
            name: "Realme GT 5",
            price: 40000,
            description: "Realme'nin en yeni modeli",
            imageUrl: "https://cdn.akakce.com/iphone/apple-iphone-16-pro-max-256-gb-uzay-siyah-z.jpg",
            category: Category.elektronik,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"6",
            name: "Kışlık mont",
            price: 4000,
            description: "Sıcak tutan mont",
            imageUrl: "https://i.dr.com.tr/dat/500/780/3455406-29708-3871671/450x450/defacto- Erkek-Regular-Fit-Kapusonlu-Siyah-Mont-P8831219-3455406-3871671.jpg",
            category: Category.giyim,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"7",
            name: "Kadın elbise",
            price: 4000,
            description: "Sıcak tutan elbise",
            imageUrl: "https://i.dr.com.tr/dat/500/780/3455406-29708-3871671/450x450/defacto- Erkek-Regular-Fit-Kapusonlu-Siyah-Mont-P8831219-3455406-3871671.jpg",
            category: Category.giyim,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"8",
            name: "Kadın eşofman takımı",
            price: 4000,
            description: "Sıcak tutan eşofman takımı",
            imageUrl: "https://i.dr.com.tr/dat/500/780/3455406-29708-3871671/450x450/defacto- Erkek-Regular-Fit-Kapusonlu-Siyah-Mont-P8831219-3455406-3871671.jpg",
            category: Category.giyim,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"9",
            name: "şık keten pantolon",
            price: 4000,
            description: "şık keten pantolon",
            imageUrl: "https://i.dr.com.tr/dat/500/780/3455406-29708-3871671/450x450/defacto- Erkek-Regular-Fit-Kapusonlu-Siyah-Mont-P8831219-3455406-3871671.jpg",
            category: Category.giyim,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"10",
            name: "kadın keten pantolon",
            price: 4000,
            description: "kadın keten pantolon",
            imageUrl: "https://i.dr.com.tr/dat/500/780/3455406-29708-3871671/450x450/defacto- Erkek-Regular-Fit-Kapusonlu-Siyah-Mont-P8831219-3455406-3871671.jpg",
            category: Category.giyim,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
        Urun(
            id:"11",
            name: "kürklü kapüşonlu sweatshirt",
            price: 4000,
            description: "kürklü kapüşonlu sweatshirt",
            imageUrl: "https://i.dr.com.tr/dat/500/780/3455406-29708-3871671/450x450/defacto- Erkek-Regular-Fit-Kapusonlu-Siyah-Mont-P8831219-3455406-3871671.jpg",
            category: Category.moda,
            stokMiktari: 10,
            rating: 4.5,
            ratingCount: 100,
        ),
    ];

    @override
    Future<List<Urun>> allfetchproducts() async {
        await Future.delayed(const Duration(seconds: 1));
        return List.from(_productstock);
    }

    @override
    Future<List<Urun>> fetchproductsbycategory(Category category) async {
        await Future.delayed(const Duration(seconds: 1));
        if (category == Category.hepsi) {
            return List.from(_productstock);
        }
        return _productstock.where((urun) => urun.category == category).toList();
    }

    @override
    Future<List<Urun>> searchbyname(String searchingname) async {
        await Future.delayed(const Duration(seconds: 1));
        if (searchingname.trim().isEmpty) {
            return List.from(_productstock);
        }
        final searchSmall = searchingname.toLowerCase();
        return _productstock.where((urun) {
            final headerSmall = urun.name.toLowerCase();
            return headerSmall.contains(searchSmall);
        }).toList();
    }
}