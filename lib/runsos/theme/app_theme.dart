import 'package:flutter/material.dart';

class AppTheme {
  static const _seed = Color(0xFF12324A);
  static const sosRed = Color(0xFFE11D48);
  static const accentAmber = Color(0xFFF4B942);
  static const panelBlue = Color(0xFF112743);
  static const panelEdge = Color(0xFF2F5D8A);
  static const glowBlue = Color(0xFF71D6C9);
  static const surfaceInk = Color(0xFF07111E);
  static const softText = Color(0xFFCCD7E5);

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      primary: _seed,
      secondary: accentAmber,
      surface: surfaceInk,
    );

    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: scheme,
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: surfaceInk,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: softText,
        displayColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: panelBlue.withValues(alpha: 0.88),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: panelEdge.withValues(alpha: 0.65)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentAmber,
          foregroundColor: const Color(0xFF1A1204),
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentAmber,
          foregroundColor: const Color(0xFF1A1204),
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF0B1830),
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: glowBlue.withValues(alpha: 0.65)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: softText),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        filled: true,
        fillColor: const Color(0xFF09172C),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: panelEdge.withValues(alpha: 0.8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: accentAmber, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: panelBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerColor: panelEdge.withValues(alpha: 0.4),
    );
  }
}
