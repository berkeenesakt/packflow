import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:packpal/core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    // Initialize with system default
    _initializeTheme();
  }

  // Get current theme mode
  ThemeMode get themeMode => _themeMode;

  // Get current theme data
  ThemeData get themeData {
    if (_themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
    return _themeMode == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }

  // Is dark mode active
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Initialize theme
  void _initializeTheme() {
    // Read from system
    _updateSystemUIOverlayStyle();

    // Listen to system changes
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      _updateSystemUIOverlayStyle();
      notifyListeners();
    };
  }

  // Set theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _updateSystemUIOverlayStyle();
    notifyListeners();
  }

  // Update system UI style based on current theme
  void _updateSystemUIOverlayStyle() {
    final isDark = isDarkMode;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark ? AppTheme.darkColorScheme.background : AppTheme.lightColorScheme.background,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }
}
