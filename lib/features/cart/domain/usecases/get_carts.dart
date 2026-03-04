import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCarts {
  final CartRepository repository;
  GetCarts(this.repository);

  Future<List<CartItem>> call() async {
    return await repository.getCarts();
  }
}