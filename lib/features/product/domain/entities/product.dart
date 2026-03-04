/// PRINSIP: Domain Driven Design (DDD) - Entity.
/// Ini adalah objek data murni. Tidak boleh ada dependency ke JSON/External library.
class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  Product({required this.id, required this.title, required this.price, required this.image});
}
