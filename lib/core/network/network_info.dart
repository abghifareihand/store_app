import 'package:connectivity_plus/connectivity_plus.dart';

/// PRINSIP: Dependency Inversion.
/// Kita membungkus library pihak ketiga (connectivity_plus) ke dalam interface.
/// Jika suatu saat library ini "deprecated", kita cukup ubah di satu tempat ini saja.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // Mengecek apakah ada koneksi aktif (Wifi/Mobile)
    return !result.contains(ConnectivityResult.none);
  }
}