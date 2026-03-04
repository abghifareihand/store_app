part of 'product_bloc.dart';

/// PRINSIP: Separation of Concerns (SoC).
/// Layer Presentation tidak boleh tahu logic ambil data, ia hanya tahu cara mengirim Event.
abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event khusus untuk get data
class LoadProducts extends ProductEvent {}

/// Event khusus untuk refresh data
class RefreshProducts extends ProductEvent {}