import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_products.dart';
import '../../../domain/entities/product.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  ProductBloc(this.getProducts) : super(ProductInitial()) {
    // Handler untuk Load (Biasanya saat buka halaman)
    on<LoadProducts>((event, emit) async {
      emit(ProductLoading()); // Kasih loading spinner di tengah
      try {
        final result = await getProducts();
        emit(ProductLoaded(result));
      } catch (e) {
        emit(ProductError("Gagal mengambil data"));
      }
    });

    // Handler untuk Refresh (Biasanya Pull-to-Refresh)
    on<RefreshProducts>((event, emit) async {
      // PRINSIP: Smooth Refresh.
      // Jangan emit ProductLoading() biar data lama nggak hilang dari layar.
      try {
        final result = await getProducts();
        emit(ProductLoaded(result));
      } catch (e) {
        // Opsional: Kamu bisa tetap di state Loaded kalau gagal refresh,
        // tapi di sini kita buat simpel dulu.
        emit(ProductError("Gagal memperbarui data"));
      }
    });
  }
}
