import '../../domain/entities/cart_item.dart';

/// PRINSIP: Single Responsibility.
/// Model bertugas melakukan mapping data (JSON).
/// Kita memisahkan Model dari Entity agar UI tidak "tercemar" logic backend.
class CartItemModel extends CartItem {
  CartItemModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
    super.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'image': image,
    'quantity': quantity,
  };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    image: json['image'],
    quantity: json['quantity'] ?? 1,
  );
}
