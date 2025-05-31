import 'package:flutter/material.dart';

class AppColors {
  // Warna utama aplikasi
  static const Color primaryColor = Color(0xFF4E71FF); // Warna biru yang diminta
  static const Color primaryColorLight = Color(0xFF7A93FF);
  static const Color primaryColorDark = Color(0xFF2952CC);
  
  // Warna aksen
  static const Color accentColor = Color(0xFFFF9800);
  
  // Warna latar belakang
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color backgroundColorDark = Color(0xFF121212);
  
  // Warna teks
  static const Color textColor = Color(0xFF212121);
  static const Color textColorLight = Color(0xFF757575);
  
  // Warna kategori pengeluaran
  static const Color foodColor = Color(0xFFFF9800);
  static const Color transportColor = Color(0xFF2196F3);
  static const Color entertainmentColor = Color(0xFF9C27B0);
  static const Color shoppingColor = Color(0xFF4CAF50);
  static const Color educationColor = Color(0xFF795548);
  static const Color healthColor = Color(0xFFF44336);
  static const Color otherColor = Color(0xFF607D8B);
  
  // Warna status anggaran
  static const Color budgetSafeColor = Color(0xFF4CAF50);
  static const Color budgetWarningColor = Color(0xFFFF9800);
  static const Color budgetDangerColor = Color(0xFFF44336);
  
  // MaterialColor untuk primarySwatch
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF4E71FF,
    <int, Color>{
      50: Color(0xFFE8EDFF),
      100: Color(0xFFC7D1FF),
      200: Color(0xFFA2B3FF),
      300: Color(0xFF7D94FF),
      400: Color(0xFF617DFF),
      500: Color(0xFF4E71FF),
      600: Color(0xFF4769FF),
      700: Color(0xFF3D5EFF),
      800: Color(0xFF3554FF),
      900: Color(0xFF2542FF),
    },
  );
}
