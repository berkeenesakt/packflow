import 'package:flutter/material.dart';

class AppTheme {
  static const lightColorScheme = ColorScheme.light(
    primary: Color(0xFF2196F3), // Vibrant blue
    primaryContainer: Color(0xFFE3F2FD),
    onPrimaryContainer: Color(0xFF1565C0),
    secondary: Color(0xFF9C27B0), // Purple accent
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE1BEE7),
    onSecondaryContainer: Color(0xFF7B1FA2),
    tertiary: Color(0xFF00BCD4), // Cyan accent
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFE0F7FA),
    onTertiaryContainer: Color(0xFF006064),
    errorContainer: Color(0xFFFFEBEE),
    onErrorContainer: Color(0xFF8C0017),
    onSurface: Color(0xFF1C1B1F),
    surfaceContainerHighest: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF49454F),
    outline: Color(0xFF79747E),
  );

  static const darkColorScheme = ColorScheme.dark(
    primary: Color(0xFF90CAF9), // Light blue for dark theme
    onPrimary: Color(0xFF0D47A1),
    primaryContainer: Color(0xFF1976D2),
    onPrimaryContainer: Color(0xFFE3F2FD),
    secondary: Color(0xFFCE93D8), // Light purple for dark theme
    secondaryContainer: Color(0xFF7B1FA2),
    onSecondaryContainer: Color(0xFFF3E5F5),
    tertiary: Color(0xFF80DEEA), // Light cyan for dark theme
    onTertiary: Color(0xFF006064),
    tertiaryContainer: Color(0xFF00838F),
    onTertiaryContainer: Color(0xFFE0F7FA),
    errorContainer: Color(0xFF8C0017),
    onErrorContainer: Color(0xFFFFEBEE),
    onSurface: Color(0xFFE6E1E5),
    surfaceContainerHighest: Color(0xFF2D2D2D),
    onSurfaceVariant: Color(0xFFCAC4D0),
    outline: Color(0xFF938F99),
  );

  static ThemeData lightTheme = _buildTheme(lightColorScheme);
  static ThemeData darkTheme = _buildTheme(darkColorScheme);

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surfaceContainerHighest,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerHighest,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
