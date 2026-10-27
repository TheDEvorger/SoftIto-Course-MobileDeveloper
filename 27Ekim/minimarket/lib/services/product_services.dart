import '../models/product.dart';
import '../models/category.dart';

abstract class ProductService {
  Future<List<Urun>> allfetchproducts();
  Future<List<Urun>> fetchproductsbycategory(Category category);
  Future<List<Urun>> searchbyname(String searchingname);
}