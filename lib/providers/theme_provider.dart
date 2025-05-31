import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString(_themeKey);

    if (savedThemeMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedThemeMode == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    String themeString;

    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }

    await prefs.setString(_themeKey, themeString);
    notifyListeners();
  }

  // Tema terang (default) tetap seperti sebelumnya
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
      bodyMedium: TextStyle(color: Colors.white54, fontFamily: 'Poppins'),
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.blue),
      trackColor: WidgetStateProperty.all(Colors.blueAccent),
    ),
  );

  // Tema gelap diperbaiki untuk kontras yang baik
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF2C2C2C),
    dividerColor: Colors.grey.shade700,
    iconTheme: const IconThemeData(color: Colors.white70),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      bodyLarge: TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
      bodyMedium: TextStyle(color: Colors.white60, fontFamily: 'Poppins'),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Poppins',
      ),
      elevation: 0,
      centerTitle: true,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.lightBlueAccent),
      trackColor: MaterialStateProperty.all(Colors.lightBlueAccent.shade100),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3A3A3A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.white54),
    ),
  );
}
