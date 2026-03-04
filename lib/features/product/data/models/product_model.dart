import '../../domain/entities/product.dart';

/// PRINSIP: Single Responsibility.
/// Model bertugas melakukan mapping data (JSON).
/// Kita memisahkan Model dari Entity agar UI tidak "tercemar" logic backend.
class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.title,
    required super.price,
    required super.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'price': price, 'image': image};
}
