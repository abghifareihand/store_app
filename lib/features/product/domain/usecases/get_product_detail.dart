import '../entities/product_detail.dart';
import '../repositories/product_repository.dart';

class GetProductDetail {
  final ProductRepository repository;

  GetProductDetail(this.repository);

  Future<ProductDetail> execute(int id) async {
    return await repository.getProductDetail(id);
  }
}