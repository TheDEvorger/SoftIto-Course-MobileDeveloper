import 'category.dart';

class Urun{
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final Category category;
  final int stokMiktari;
  final double rating;
  final int ratingCount;

  const Urun({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.stokMiktari,
    required this.rating,
    required this.ratingCount,
  });

  Urun copywith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    Category? category,
    int? stokMiktari,
    double? rating,
    int? ratingCount,
  }) {
    return Urun(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stokMiktari: stokMiktari ?? this.stokMiktari,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }

  @override
  String toString() {
    return 'Urun(id: $id, name: $name, price: $price, description: $description, imageUrl: $imageUrl, category: $category, stokMiktari: $stokMiktari, rating: $rating, ratingCount: $ratingCount)';
  }
}