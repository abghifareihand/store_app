import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/cart_item.dart';
import '../../../domain/usecases/add_to_cart.dart';
import '../../../domain/usecases/get_carts.dart';
import '../../../domain/usecases/remove_from_cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCarts getCarts;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  CartBloc({required this.getCarts, required this.addToCart, required this.removeFromCart})
    : super(CartInitial()) {
    // Handler untuk Load data keranjang dari local storage
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final items = await getCarts();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError("Gagal mengambil data keranjang"));
      }
    });

    // Handler untuk tambah produk ke keranjang
    // Handler untuk tambah produk ke keranjang
    on<AddProduct>((event, emit) async {
      try {
        // BLOC TIDAK PERLU HITUNG LAGI. Cukup suruh Repository.
        await addToCart(event.item);

        // Refresh UI
        final items = await getCarts();
        emit(CartLoaded(List.from(items)));
      } catch (e) {
        emit(CartError("Gagal update keranjang"));
      }
    });

    // Handler untuk hapus produk dari keranjang
    on<RemoveProduct>((event, emit) async {
      try {
        await removeFromCart(event.productId);
        // Sinkronisasi ulang data setelah dihapus
        final items = await getCarts();
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError("Gagal menghapus barang dari keranjang"));
      }
    });
  }
}
