import '../../../../core/network/api_client.dart';
import '../models/product_detail_model.dart';
import '../models/product_model.dart';

/// PRINSIP: Interface Segregation.
/// Mengapa bagus: Remote Data Source hanya tahu cara ambil data dari Network.
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProductsFromApi();
  Future<ProductDetailModel> getProductDetailFromApi(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient; // Menggunakan ApiClient pusat
  ProductRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProductsFromApi() async {
    final response = await apiClient.get('/products');
    return (response.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductDetailModel> getProductDetailFromApi(int id) async {
    final response = await apiClient.get('/products/$id');
    return ProductDetailModel.fromJson(response.data);
  }
}