import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/components/custom_appbar.dart';
import 'package:store_app/core/components/custom_button.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/core/utils/formatter.dart';
import 'package:store_app/features/cart/presentation/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/presentation/widgets/cart_item_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Text(
          'Cart',
          style: AppFonts.semiBold.copyWith(color: AppColors.primary, fontSize: 16),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return CartItemCard(
                  item: item,
                  onRemove: () => context.read<CartBloc>().add(RemoveProduct(item.id)),
                  onIncrement: () {
                    context.read<CartBloc>().add(AddProduct(item.copyWith(quantity: 1)));
                  },
                  onDecrement: () {
                    if (item.quantity > 1) {
                      context.read<CartBloc>().add(AddProduct(item.copyWith(quantity: -1)));
                    } else {
                      context.read<CartBloc>().add(RemoveProduct(item.id));
                    }
                  },
                );
              },
            );
          }

          if (state is CartError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.grey)),
          ),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              double totalPrice = 0;
              bool isLoaded = false;
              if (state is CartLoaded) {
                totalPrice = state.totalPrice;
                isLoaded = state.items.isNotEmpty;
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Harga', style: AppFonts.semiBold.copyWith(fontSize: 12)),
                        Text(
                          rupiahFormat.format(totalPrice * 16000),
                          style: AppFonts.semiBold.copyWith(fontSize: 18, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Button.filled(onPressed: isLoaded ? () {} : null, label: 'Checkout'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Wah, keranjangmu masih kosong!', style: AppFonts.medium),
        ],
      ),
    );
  }
}
