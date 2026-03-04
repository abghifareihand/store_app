import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

/// Fungsi: Mengelola penyimpanan keranjang belanja secara lokal.
/// Mengapa bagus: Memungkinkan user menyimpan belanjaan tanpa perlu login/koneksi internet,
/// serta menjaga persistensi data saat aplikasi ditutup.
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCart();
  Future<void> saveCart(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  CartLocalDataSourceImpl(this.sharedPreferences);

  static const String _key = 'CACHED_CART';

  @override
  Future<List<CartItemModel>> getCart() async {
    final jsonString = sharedPreferences.getString(_key);
    if (jsonString != null) {
      final List decodeData = json.decode(jsonString);
      return decodeData.map((item) => CartItemModel.fromJson(item)).toList();
    }
    // Mengembalikan list kosong jika belum ada data di keranjang
    return [];
  }

  @override
  Future<void> saveCart(List<CartItemModel> items) async {
    final String jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await sharedPreferences.setString(_key, jsonString);
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(_key);
  }
}
