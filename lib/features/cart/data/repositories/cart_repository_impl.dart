import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

/// PRINSIP: Data Mapping & Business Logic.
/// Repository ini bertugas menjembatani antara Entity di Domain Layer
/// dan Model di Data Layer, serta menangani logika penambahan quantity.
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  CartRepositoryImpl(this.localDataSource);

  @override
  Future<List<CartItem>> getCarts() async {
    return await localDataSource.getCart();
  }

  @override
  Future<void> addToCart(CartItem item) async {
    final List<CartItemModel> currentCart = await localDataSource.getCart();
    final index = currentCart.indexWhere((element) => element.id == item.id);

    if (index >= 0) {
      final existingItem = currentCart[index];
      // DI SINI LOGIC PERHITUNGAN YANG BENAR
      final newQuantity = existingItem.quantity + item.quantity;

      if (newQuantity <= 0) {
        currentCart.removeAt(index);
      } else {
        currentCart[index] = CartItemModel(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          image: existingItem.image,
          quantity: newQuantity,
        );
      }
    } else {
      // Jika belum ada, langsung tambah
      currentCart.add(
        CartItemModel(
          id: item.id,
          title: item.title,
          price: item.price,
          image: item.image,
          quantity: item.quantity,
        ),
      );
    }
    await localDataSource.saveCart(currentCart);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final currentCart = await localDataSource.getCart();
    currentCart.removeWhere((item) => item.id == productId);
    await localDataSource.saveCart(currentCart);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}
