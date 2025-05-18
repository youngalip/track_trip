import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default tema adalah terang (light)
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Ganti tema antara terang dan gelap
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Set tema secara eksplisit
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
