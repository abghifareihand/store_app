import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/core/components/custom_appbar.dart';
import 'package:store_app/core/components/custom_button.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/core/utils/formatter.dart';
import 'package:store_app/features/cart/domain/entities/cart_item.dart';
import 'package:store_app/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/presentation/pages/cart_page.dart';
import 'package:store_app/features/product/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:store_app/injection.dart';

/// PRINSIP: Dependency Injection via BlocProvider.
/// Mengapa bagus: Memastikan ProductDetailBloc hanya tersedia untuk scope halaman ini,
/// serta menjamin auto-dispose saat halaman tidak lagi digunakan.
class ProductDetailPage extends StatelessWidget {
  final int productId; // Terima ID dari halaman sebelumnya
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductDetailBloc>()..add(LoadProductDetail(productId)),
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Product Detail',
          style: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 16),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int totalItems = 0;
              if (state is CartLoaded) {
                // Menghitung total barang yang ada di list keranjang
                totalItems = state.items.fold(0, (sum, item) => sum + item.quantity);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
                },
                child: Center(
                  child: Badge(
                    label: Text(
                      totalItems.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    isLabelVisible: totalItems > 0,
                    backgroundColor: AppColors.primary,
                    offset: const Offset(4, -4),
                    child: SvgPicture.asset('assets/icons/cart.svg', width: 24, height: 24),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductDetailLoaded) {
            final product = state.product;
            return ListView(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: AppColors.grey.withValues(alpha: 0.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        product.category.toUpperCase(),
                        style: AppFonts.regular.copyWith(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(product.title, style: AppFonts.bold.copyWith(fontSize: 16)),
                      const SizedBox(height: 12),

                      // Price
                      Text(
                        rupiahFormat.format(product.price * 16000),
                        style: AppFonts.semiBold.copyWith(fontSize: 18, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text('Description', style: AppFonts.semiBold.copyWith(fontSize: 16)),
                      Text(
                        product.description,
                        style: AppFonts.regular.copyWith(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is ProductDetailError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          return const SizedBox.shrink();
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.grey)),
          ),
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              VoidCallback? onPressed;
              if (state is ProductDetailLoaded) {
                final product = state.product;
                onPressed = () {
                  final cartItem = CartItem(
                    id: product.id,
                    title: product.title,
                    price: product.price,
                    image: product.image,
                    quantity: 1,
                  );
                  context.read<CartBloc>().add(AddProduct(cartItem));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} ditambah ke keranjang'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                    ),
                  );
                };
              }
              return Button.filled(onPressed: onPressed, label: 'Add to Cart');
            },
          ),
        ),
      ),
    );
  }
}
