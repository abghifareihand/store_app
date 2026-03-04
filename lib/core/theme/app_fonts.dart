import 'package:flutter/material.dart';

/// PRINSIP: Design System Typography.
/// Kita mendefinisikan "Type Scale" di sini agar konsisten di seluruh aplikasi.
class AppFonts {
  // Font Family Constant
  static const String fontFamily = 'Poppins';

  static TextStyle _textStyle({
    required FontWeight fontWeight,
    Color color = Colors.black,
    double fontSize = 14.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize,
      height: height,
    );
  }

  static TextStyle get light => _textStyle(fontWeight: FontWeight.w300);
  static TextStyle get regular => _textStyle(fontWeight: FontWeight.w400);
  static TextStyle get medium => _textStyle(fontWeight: FontWeight.w500);
  static TextStyle get semiBold => _textStyle(fontWeight: FontWeight.w600);
  static TextStyle get bold => _textStyle(fontWeight: FontWeight.w700);
}
