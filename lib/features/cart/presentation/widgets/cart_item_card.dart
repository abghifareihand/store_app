import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';
import 'package:store_app/core/utils/formatter.dart';
import 'package:store_app/features/cart/domain/entities/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Produk (Tetap sama)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppFonts.medium.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  rupiahFormat.format(item.price * 16000),
                  style: AppFonts.semiBold.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),

          // Action Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              ),
              const SizedBox(height: 8),
              // Tombol Plus Minus
              Row(
                children: [
                  // Tombol Minus / Delete
                  _buildQtyBtn(
                    item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                    onDecrement,
                    color: item.quantity == 1 ? Colors.red : AppColors.black,
                  ),

                  SizedBox(
                    width: 32,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: AppFonts.semiBold.copyWith(fontSize: 14),
                    ),
                  ),

                  // Tombol Plus
                  _buildQtyBtn(Icons.add, onIncrement),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget buat tombol biar gak duplikat kodenya
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap, {Color color = AppColors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(
            color: color == Colors.red ? Colors.red.withValues(alpha: 0.5) : AppColors.grey,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
