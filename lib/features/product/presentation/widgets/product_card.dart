import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/core/utils/formatter.dart';
import 'package:store_app/features/cart/domain/entities/cart_item.dart';
import 'package:store_app/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/product/domain/entities/product.dart';
import 'package:store_app/features/product/presentation/pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailPage(productId: product.id)),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// IMAGE (rounded + padding + proporsional)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.grey.withValues(alpha: 0.2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// TITLE
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.medium.copyWith(fontSize: 12, color: AppColors.black),
                ),

                const SizedBox(height: 6),

                /// PRICE
                Text(
                  rupiahFormat.format(product.price * 16000),
                  style: AppFonts.medium.copyWith(fontSize: 12, color: AppColors.primary),
                ),
              ],
            ),
          ),

          /// ICON CART
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                // 1. Buat object CartItem dari data Product
                final cartItem = CartItem(
                  id: product.id,
                  title: product.title,
                  price: product.price,
                  image: product.image,
                  quantity: 1, // Default tambah 1
                );

                // 2. Panggil Bloc untuk tambah ke keranjang lokal
                context.read<CartBloc>().add(AddProduct(cartItem));

                // 3. Kasih feedback simpel ke user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} ditambah ke keranjang'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SvgPicture.asset('assets/icons/order.svg', width: 18, height: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
