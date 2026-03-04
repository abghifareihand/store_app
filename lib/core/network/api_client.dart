import 'package:dio/dio.dart';
import '../config/app_config.dart';

/// PRINSIP: Abstraction & Centralization.
/// Fungsi: Wrapper untuk Dio agar konfigurasi network (timeout, interceptor, baseurl)
/// tidak tersebar di banyak file.
/// Mengapa bagus: Kalau besok kita mau ganti Dio ke library lain, atau mau nambahin
/// logic "Auto Logout kalau Token Expired", kita cukup ubah di satu file ini.
class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    // Tambahkan Logger Interceptor biar pas debugging enak liat request/response
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  // Generic Get Request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // Generic Post Request
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  // Generic Put Request
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // Generic Delete Request
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
