import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

// Features - Product
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/get_product_detail.dart';
import 'features/product/presentation/bloc/product/product_bloc.dart';
import 'features/product/presentation/bloc/product_detail/product_detail_bloc.dart';

// Features - Auth
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/get_logged_in_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';

// Features - Cart
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/get_carts.dart';
import 'features/cart/domain/usecases/add_to_cart.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart';
import 'features/cart/presentation/bloc/cart/cart_bloc.dart';

final sl = GetIt.instance;

/// PRINSIP: Dependency Injection (DI) & Service Locator.
Future<void> initInjector() async {
  // ===========================================================================
  // 1. EXTERNAL (Library Pihak Ketiga)
  // ===========================================================================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  // ===========================================================================
  // 2. CORE (Global Utilities)
  // ===========================================================================
  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ===========================================================================
  // 3. FEATURE: PRODUCT
  // ===========================================================================

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));

  // Bloc
  sl.registerFactory(() => ProductBloc(sl()));
  sl.registerFactory(() => ProductDetailBloc(sl()));

  // ===========================================================================
  // 4. FEATURE: AUTH
  // ===========================================================================

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Case
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => GetLoggedInUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(loginUser: sl(), getLoggedInUser: sl(), logoutUser: sl()));

  // ===========================================================================
  // 5. FEATURE: CART
  // ===========================================================================

  // Data Sources
  sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));

  // Use Case
  sl.registerLazySingleton(() => GetCarts(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));

  // Bloc
  // Menggunakan factory karena kita ingin state cart di-refresh sesuai lifecycle UI
  sl.registerFactory(() => CartBloc(getCarts: sl(), addToCart: sl(), removeFromCart: sl()));
}
