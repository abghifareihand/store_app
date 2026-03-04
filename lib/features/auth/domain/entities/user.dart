/// PRINSIP: Domain Driven Design (DDD) - Entity.
/// Ini adalah objek data murni. Tidak boleh ada dependency ke JSON/External library.
class User {
  final String username;

  User({required this.username});
}
