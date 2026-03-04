import 'package:flutter/material.dart';
import 'package:store_app/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final double titleSpacing;
  final Color backgroundColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    this.leading,
    this.titleWidget,
    this.actions,
    this.titleSpacing = 16,
    this.backgroundColor = AppColors.white,
    this.elevation = 0,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: leading,
      title: titleWidget,
      centerTitle: centerTitle,
      scrolledUnderElevation: 0,
      actions: actions,
      titleSpacing: titleSpacing,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.grey.withValues(alpha: 0.05)),
      ),
    );
  }
}
