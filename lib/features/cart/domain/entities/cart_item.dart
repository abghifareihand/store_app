/// PRINSIP: Domain Driven Design (DDD) - Entity.
/// Ini adalah objek data murni. Tidak boleh ada dependency ke JSON/External library.
class CartItem {
  final int id;
  final String title;
  final double price;
  final String image;
  final int quantity;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
  });

  // Manual copyWith tanpa library tambahan
  CartItem copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
}