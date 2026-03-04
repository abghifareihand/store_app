import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/get_product_detail.dart';
import '../../../domain/entities/product_detail.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetail getProductDetail;
  ProductDetailBloc(this.getProductDetail) : super(ProductDetailInitial()) {
    // Handler untuk Load Detail (Biasanya saat halaman pertama kali dibuka)
    on<LoadProductDetail>((event, emit) async {
      emit(ProductDetailLoading()); // Tampilkan loading spinner
      try {
        final result = await getProductDetail.execute(event.id);
        emit(ProductDetailLoaded(result));
      } catch (e) {
        emit(ProductDetailError("Gagal mengambil detail produk"));
      }
    });

    // Handler untuk Refresh Detail
    on<RefreshProductDetail>((event, emit) async {
      // PRINSIP: Smooth Refresh.
      // Langsung tembak datanya tanpa emit Loading agar UI tidak berkedip putih
      try {
        final result = await getProductDetail.execute(event.id);
        emit(ProductDetailLoaded(result));
      } catch (e) {
        emit(ProductDetailError("Gagal memperbarui detail produk"));
      }
    });
  }
}
