import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:store_app/core/components/custom_appbar.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/features/auth/presentation/pages/profile_page.dart';
import 'package:store_app/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/presentation/pages/cart_page.dart';
import 'package:store_app/features/product/presentation/bloc/product/product_bloc.dart';
import 'package:store_app/features/product/presentation/widgets/banner_slider.dart';
import 'package:store_app/features/product/presentation/widgets/product_card.dart';
import 'package:store_app/injection.dart';

/// PRINSIP: Dependency Injection via BlocProvider.
/// Mengapa bagus: Memastikan ProductBloc hanya tersedia untuk scope halaman ini,
/// serta menjamin auto-dispose saat halaman tidak lagi digunakan.
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductBloc>()..add(LoadProducts()),
      child: const ProductView(),
    );
  }
}

/// PRINSIP: Pure View Component.
/// Fokus hanya pada rendering UI berdasarkan State.
/// Memisahkan UI dari logika inisialisasi mempermudah Unit Testing.
class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Store App',
          style: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 16),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            child: SvgPicture.asset('assets/icons/user.svg'),
          ),
          const SizedBox(width: 20),
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
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                // Kirim event refresh ke Bloc
                context.read<ProductBloc>().add(RefreshProducts());
              },
              child: ListView(
                children: [
                  /// Banner Local
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: BannerSlider(
                      items: ['assets/images/banner1.png', 'assets/images/banner2.png'],
                    ),
                  ),

                  /// Tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Product',
                          style: AppFonts.semiBold.copyWith(fontSize: 16, color: AppColors.black),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'See All',
                            style: AppFonts.semiBold.copyWith(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Product API
                  GridView.builder(
                    padding: EdgeInsets.all(20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(product: product);
                    },
                  ),
                ],
              ),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  ElevatedButton(
                    onPressed: () => context.read<ProductBloc>().add(LoadProducts()),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
