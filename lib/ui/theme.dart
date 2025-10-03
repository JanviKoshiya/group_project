import 'package:flutter/material.dart';

class AppTheme {
  static const _brandGreen = Color(0xFF00A86B);
  static const _brandBlue = Color(0xFF0066FF);
  static const _brandOrange = Color(0xFFFF6A00);

  static final _lightColorScheme = ColorScheme.light(
    primary: _brandBlue,
    secondary: _brandOrange,
    surface: Colors.white,
  );

  static const _darkColorScheme = ColorScheme.dark(
    primary: _brandGreen,
    secondary: _brandOrange,
    surface: Color(0xFF121212),
  );

  static final lightTheme = ThemeData(
    colorScheme: _lightColorScheme,
    primaryColor: _lightColorScheme.primary,
    scaffoldBackgroundColor: _lightColorScheme.background,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.surface,
      foregroundColor: Colors.black87,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 13),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: _darkColorScheme,
    primaryColor: _darkColorScheme.primary,
    scaffoldBackgroundColor: _darkColorScheme.background,
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.surface,
      foregroundColor: Colors.white,
      elevation: 0.5,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 13, color: Colors.white70),
    ),
  );
}
