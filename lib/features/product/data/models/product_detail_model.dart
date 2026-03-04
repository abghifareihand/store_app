import '../../domain/entities/product_detail.dart';

/// PRINSIP: Single Responsibility.
/// Model bertugas melakukan mapping data (JSON).
/// Kita memisahkan Model dari Entity agar UI tidak "tercemar" logic backend.
class ProductDetailModel extends ProductDetail {
  ProductDetailModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.category,
    required super.image,
    required super.rating,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: json['rating'] != null ? (json['rating']['rate'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': {'rate': rating},
    };
  }
}
