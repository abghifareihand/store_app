import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_app/core/theme/app_colors.dart';
import 'package:store_app/core/theme/app_fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final Function(String value)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool showLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final String? errorText;
  final int maxLines;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  // --- Validation ---
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? counterText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.showLabel = true,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.errorText,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    // --- Validation ---
    this.maxLength,
    this.inputFormatters,
    this.counterText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(widget.label, style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14)),
          const SizedBox(height: 8.0),
        ],
        TextFormField(
          cursorColor: AppColors.primary,
          style: AppFonts.medium.copyWith(color: AppColors.black, fontSize: 14),
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          obscureText: widget.obscureText ? _obscureText : false,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,

          // --- Pasang di sini ---
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            // Gunakan "" agar angka 0/6 di bawah field hilang
            counterText: widget.counterText,
            hintStyle: AppFonts.light.copyWith(color: AppColors.grey, fontSize: 14),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.grey,
                    ),
                    onPressed: _toggleObscureText,
                  )
                : widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.red[800]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.red[800]!),
            ),
            hintText: widget.hintText,
            errorText: widget.errorText,
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          ),
        ),
      ],
    );
  }
}
