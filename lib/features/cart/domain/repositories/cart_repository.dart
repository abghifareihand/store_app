import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCarts();
  Future<void> addToCart(CartItem item);
  Future<void> removeFromCart(int productId);
  Future<void> clearCart();
}