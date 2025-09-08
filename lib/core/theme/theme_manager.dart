import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFFFFFFF); // #FFFFFF
  static const Color lightPrimaryRed = Color(0xFFFF3B30); // #FF3B30
  static const Color lightSecondaryGreen = Color(0xFF27AE60); // #27AE60
  static const Color lightTextDark = Color(0xFF1C1C1C); // #1C1C1C
  static const Color lightAccentYellow = Color(0xFFFFB84D); // #FFB84D

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0D0D0D); // #0D0D0D
  static const Color darkPrimaryRed = Color(0xFFFF3B30); // #FF3B30 (same as light mode)
  static const Color darkSecondaryGreen = Color(0xFF2ECC71); // #2ECC71
  static const Color darkTextLight = Color(0xFFF5F5F5); // #F5F5F5
  static const Color darkAccentYellow = Color(0xFFFFCC66); // #FFCC66

  // Current Colors (based on mode)
  Color get backgroundColor => _isDarkMode ? darkBackground : lightBackground;
  Color get primaryRed => _isDarkMode ? darkPrimaryRed : lightPrimaryRed;
  Color get secondaryGreen => _isDarkMode ? darkSecondaryGreen : lightSecondaryGreen;
  Color get textColor => _isDarkMode ? darkTextLight : lightTextDark;
  Color get accentYellow => _isDarkMode ? darkAccentYellow : lightAccentYellow;

  // Additional utility colors
  Color get surfaceColor => _isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA);
  Color get cardColor => _isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
  Color get borderColor => _isDarkMode ? const Color(0xFF404040) : const Color(0xFFE0E0E0);
  Color get shadowColor => _isDarkMode ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.1);

  ThemeManager() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];
    _isDarkMode = _themeMode == ThemeMode.dark;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _isDarkMode = mode == ThemeMode.dark;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  // Gradient colors for different elements
  List<Color> get primaryGradient => _isDarkMode 
      ? [darkPrimaryRed, darkPrimaryRed.withOpacity(0.8)]
      : [lightPrimaryRed, lightPrimaryRed.withOpacity(0.8)];

  List<Color> get secondaryGradient => _isDarkMode
      ? [darkSecondaryGreen, darkSecondaryGreen.withOpacity(0.8)]
      : [lightSecondaryGreen, lightSecondaryGreen.withOpacity(0.8)];

  List<Color> get accentGradient => _isDarkMode
      ? [darkAccentYellow, darkAccentYellow.withOpacity(0.8)]
      : [lightAccentYellow, lightAccentYellow.withOpacity(0.8)];

  // Header gradient
  List<Color> get headerGradient => _isDarkMode
      ? [darkPrimaryRed, darkPrimaryRed.withOpacity(0.9), darkBackground]
      : [lightPrimaryRed, lightPrimaryRed.withOpacity(0.9), lightBackground];

  // Category colors (variations of primary colors)
  List<Color> get categoryColors => _isDarkMode
      ? [
          darkPrimaryRed,
          darkPrimaryRed.withOpacity(0.8),
          darkAccentYellow,
          darkSecondaryGreen,
          darkPrimaryRed.withOpacity(0.6),
          darkAccentYellow.withOpacity(0.8),
        ]
      : [
          lightPrimaryRed,
          lightPrimaryRed.withOpacity(0.8),
          lightAccentYellow,
          lightSecondaryGreen,
          lightPrimaryRed.withOpacity(0.6),
          lightAccentYellow.withOpacity(0.8),
        ];
}
