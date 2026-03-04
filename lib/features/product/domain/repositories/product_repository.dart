import '../entities/product.dart';
import '../entities/product_detail.dart';

/// PRINSIP: Abstraction.
/// Kontrak yang menentukan APA yang bisa dilakukan, bukan BAGAIMANA cara melakukannya.
abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<ProductDetail> getProductDetail(int id);
}
