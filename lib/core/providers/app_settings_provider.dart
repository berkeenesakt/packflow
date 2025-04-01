import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packpal/core/enums/locales.dart';
import 'package:packpal/core/theme/app_theme.dart';

class AppSettingsProvider extends ChangeNotifier {
  // Constants for Hive storage
  static const String _boxName = 'app_settings';
  static const String _themeKey = 'theme_mode';
  static const String _localeKey = 'locale';

  // Theme settings
  ThemeMode _themeMode = ThemeMode.system;

  // Language settings
  Locale _locale = const Locale('en');

  final Box _box;

  AppSettingsProvider({Box? box}) : _box = box ?? Hive.box(_boxName) {
    // Load saved settings
    _loadSettings();
    // Initialize theme
    _initializeTheme();
  }

  // THEME RELATED GETTERS AND METHODS
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
    // Update system UI style
    _updateSystemUIOverlayStyle();

    // Listen to system changes
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      _updateSystemUIOverlayStyle();
      notifyListeners();
    };
  }

  // Load settings from Hive
  void _loadSettings() {
    // Load theme setting
    final savedThemeMode = _box.get(_themeKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values[savedThemeMode as int];
    }

    // Load locale setting
    final savedLocale = _box.get(_localeKey);
    if (savedLocale != null) {
      final parts = (savedLocale as String).split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
      } else if (parts.length == 1) {
        _locale = Locale(parts[0]);
      }
    }
  }

  // Set theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;

    // Save to Hive
    _box.put(_themeKey, mode.index);

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

  // LANGUAGE RELATED GETTERS AND METHODS
  // Get current locale
  Locale get locale => _locale;

  // Set locale
  void setLocale(BuildContext context, Locale locale) {
    _locale = locale;

    // Save to Hive
    final localeString =
        locale.countryCode != null ? '${locale.languageCode}_${locale.countryCode}' : locale.languageCode;
    _box.put(_localeKey, localeString);

    context.setLocale(locale);
    notifyListeners();
  }

  // Get the current locale enum
  Locales get currentLocale {
    return _locale.languageCode == 'tr' ? Locales.tr : Locales.en;
  }
}
