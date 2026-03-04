import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_detail_model.dart';
import '../models/product_model.dart';

/// Fungsi: Caching data ke storage lokal.
/// Penting untuk presentasi: Strategi Offline-First.
abstract class ProductLocalDataSource {
  // List
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getLastProducts();

  // Detail
  Future<void> cacheProductDetail(ProductDetailModel detailToCache);
  Future<ProductDetailModel> getLastProductDetail(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProductLocalDataSourceImpl(this.sharedPreferences);

  static const String key = 'CACHED_PRODUCT';

  @override
  Future<void> cacheProducts(List<ProductModel> products) {
    final List<String> jsonList = products.map((p) => json.encode(p.toJson())).toList();
    return sharedPreferences.setStringList(key, jsonList);
  }

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final jsonList = sharedPreferences.getStringList(key);
    if (jsonList != null) {
      return jsonList.map((e) => ProductModel.fromJson(json.decode(e))).toList();
    }
    throw Exception("Cache Miss: No local data found");
  }

  @override
  Future<void> cacheProductDetail(ProductDetailModel detailToCache) async {
    final jsonString = json.encode(detailToCache.toJson());
    await sharedPreferences.setString('product_detail_${detailToCache.id}', jsonString);
  }

  @override
  Future<ProductDetailModel> getLastProductDetail(int id) async {
    final jsonString = sharedPreferences.getString('product_detail_$id');
    if (jsonString != null) {
      return ProductDetailModel.fromJson(json.decode(jsonString));
    } else {
      throw Exception("Cache Miss: No local data found");
    }
  }
}
