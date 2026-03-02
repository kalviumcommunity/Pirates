import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF0A1B3D); // deep blue
  static const sosRed = Color(0xFFD7263D);

  static ThemeData dark() {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
        primary: _seed,
        secondary: sosRed,
      ),
      useMaterial3: true,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
