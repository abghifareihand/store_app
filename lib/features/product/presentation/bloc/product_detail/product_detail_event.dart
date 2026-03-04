part of 'product_detail_bloc.dart';

/// PRINSIP: Separation of Concerns (SoC).
/// Layer Presentation tidak boleh tahu logic ambil data, ia hanya tahu cara mengirim Event.
abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event khusus untuk get data pakai id
class LoadProductDetail extends ProductDetailEvent {
  final int id;
  LoadProductDetail(this.id);

  @override
  List<Object?> get props => [id];
}

/// Event khusus untuk refresh data pakai id
class RefreshProductDetail extends ProductDetailEvent {
  final int id;
  RefreshProductDetail(this.id);

  @override
  List<Object?> get props => [id];
}
