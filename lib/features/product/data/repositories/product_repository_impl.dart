import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/product_local_data_source.dart';

/// PRINSIP: Dependency Inversion.
/// Fungsi: Memilih sumber data (Remote vs Local) berdasarkan koneksi.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> fetchProducts() async {
    if (await networkInfo.isConnected) {
      try {
        // Ambil dari API
        final remoteProducts = await remoteDataSource.getProductsFromApi();
        // Simpan ke Cache (Optional tapi bagus buat offline mode)
        await localDataSource.cacheProducts(remoteProducts);
        return remoteProducts;
      } catch (e) {
        // Kalau API gagal, coba ambil dari local
        return await localDataSource.getLastProducts();
      }
    } else {
      // Jika offline, langsung ambil dari local
      return await localDataSource.getLastProducts();
    }
  }

  @override
  Future<ProductDetail> getProductDetail(int id) async {
    if (await networkInfo.isConnected) {
      try {
        // Ambil dari API
        final remoteDetail = await remoteDataSource.getProductDetailFromApi(id);
        // Simpan ke Cache (Optional tapi bagus buat offline mode)
        await localDataSource.cacheProductDetail(remoteDetail);
        return remoteDetail;
      } catch (e) {
        // Kalau API gagal, coba ambil dari local
        return await localDataSource.getLastProductDetail(id);
      }
    } else {
      // Jika offline, langsung ambil dari local
      return await localDataSource.getLastProductDetail(id);
    }
  }
}
