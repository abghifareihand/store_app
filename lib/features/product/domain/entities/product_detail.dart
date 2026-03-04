/// PRINSIP: Independent Entity.
/// Tidak extend siapapun. Lebih mudah di-maintenance secara terpisah.
class ProductDetail {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;

  ProductDetail({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });
}