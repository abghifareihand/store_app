part of 'product_detail_bloc.dart';

/// PRINSIP: Value Equality (via Equatable).
/// Mengapa bagus: BLoC tidak akan menembak State yang sama dua kali ke UI. 
/// Ini menghemat resource (CPU & Battery) karena menghindari rebuild UI yang tidak perlu.
abstract class ProductDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {}
final class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetail product; 
  ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDetailError extends ProductDetailState {
  final String message;
  ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}