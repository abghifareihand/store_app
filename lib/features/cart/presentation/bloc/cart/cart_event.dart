part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddProduct extends CartEvent {
  final CartItem item;
  AddProduct(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveProduct extends CartEvent {
  final int productId;
  RemoveProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}