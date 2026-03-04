import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// PRINSIP: Single Responsibility Principle (SRP).
/// Kelas ini hanya punya satu tugas spesifik: Mengambil data produk.
/// Mengapa bagus: Memisahkan "Apa yang aplikasi lakukan" (Business Logic) 
/// dari "Bagaimana UI menampilkannya" (Presentation).
class GetProducts {
  final ProductRepository repository;
  GetProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.fetchProducts();
  }
}