part of 'product_bloc.dart';

/// PRINSIP: Value Equality (via Equatable).
/// Mengapa bagus: BLoC tidak akan menembak State yang sama dua kali ke UI. 
/// Ini menghemat resource (CPU & Battery) karena menghindari rebuild UI yang tidak perlu.
abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);

  @override
  List<Object?> get props => [products]; // Membandingkan isi list produk
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
