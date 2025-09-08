import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_manager.dart';

class AppTheme {
  // Light Mode Colors
  static const Color lightBackground = Color(0xFFFFFFFF); // #FFFFFF
  static const Color lightPrimaryRed = Color(0xFFFF3B30); // #FF3B30
  static const Color lightSecondaryGreen = Color(0xFF27AE60); // #27AE60
  static const Color lightTextDark = Color(0xFF1C1C1C); // #1C1C1C
  static const Color lightAccentYellow = Color(0xFFFFB84D); // #FFB84D

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0D0D0D); // #0D0D0D
  static const Color darkPrimaryRed = Color(0xFFFF6B35); // #FF6B35
  static const Color darkSecondaryGreen = Color(0xFF2ECC71); // #2ECC71
  static const Color darkTextLight = Color(0xFFF5F5F5); // #F5F5F5
  static const Color darkAccentYellow = Color(0xFFFFCC66); // #FFCC66

  // Legacy colors for backward compatibility
  static const Color primaryColor = lightPrimaryRed;
  static const Color primaryDarkColor = darkPrimaryRed;
  static const Color primaryLightColor = Color(0x4DFF3B30); // lightPrimaryRed.withOpacity(0.3)
  static const Color secondaryColor = lightSecondaryGreen;
  static const Color accentColor = lightAccentYellow;
  
  static const Color backgroundColor = lightBackground;
  static const Color surfaceColor = lightBackground;
  static const Color cardColor = lightBackground;
  
  static const Color textPrimaryColor = lightTextDark;
  static const Color textSecondaryColor = Color(0xFF4A5568);
  static const Color textTertiaryColor = Color(0xFF718096);
  
  static const Color successColor = lightSecondaryGreen;
  static const Color warningColor = lightAccentYellow;
  static const Color errorColor = lightPrimaryRed;
  static const Color infoColor = Color(0xFF4299E1);
  
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFE2E8F0);
  static const Color shadowColor = Color(0x1A000000);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, primaryDarkColor],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryColor, Color(0xFF2C7A7B)],
  );
  
  // Text Styles
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.2,
  );
  
  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    height: 1.2,
  );
  
  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.3,
  );
  
  static TextStyle get heading4 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.3,
  );
  
  static TextStyle get heading5 => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.4,
  );
  
  static TextStyle get heading6 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    height: 1.4,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
    height: 1.5,
  );
  
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    height: 1.4,
  );
  
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textTertiaryColor,
    height: 1.4,
  );
  
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );
  
  static TextStyle get buttonSmall => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusXXL = 24.0;
  static const double radiusRound = 50.0;
  
  // Shadows
  static List<BoxShadow> get shadowS => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowM => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get shadowL => [
    BoxShadow(
      color: shadowColor,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryLightColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryColor,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        headlineLarge: heading1,
        headlineMedium: heading2,
        headlineSmall: heading3,
        titleLarge: heading4,
        titleMedium: heading5,
        titleSmall: heading6,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: button,
        labelMedium: buttonSmall,
        labelSmall: caption,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: heading6,
        iconTheme: const IconThemeData(color: textPrimaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          textStyle: button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        hintStyle: bodyMedium.copyWith(color: textTertiaryColor),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
          side: const BorderSide(color: borderColor),
        ),
        margin: const EdgeInsets.all(spacingS),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textTertiaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryRed,
        primaryContainer: const Color(0x4DFF6B35), // darkPrimaryRed.withOpacity(0.3)
        secondary: darkSecondaryGreen,
        surface: Color(0xFF1A1A1A),
        surfaceContainerHighest: Color(0xFF2D2D2D),
        error: darkPrimaryRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextLight,
        onError: Colors.white,
        background: darkBackground,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: TextTheme(
        headlineLarge: heading1.copyWith(color: darkTextLight),
        headlineMedium: heading2.copyWith(color: darkTextLight),
        headlineSmall: heading3.copyWith(color: darkTextLight),
        titleLarge: heading4.copyWith(color: darkTextLight),
        titleMedium: heading5.copyWith(color: darkTextLight),
        titleSmall: heading6.copyWith(color: darkTextLight),
        bodyLarge: bodyLarge.copyWith(color: darkTextLight),
        bodyMedium: bodyMedium.copyWith(color: darkTextLight),
        bodySmall: bodySmall.copyWith(color: darkTextLight.withOpacity(0.7)),
        labelLarge: button,
        labelMedium: buttonSmall,
        labelSmall: caption.copyWith(color: darkTextLight.withOpacity(0.6)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkTextLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: heading6.copyWith(color: darkTextLight),
        iconTheme: const IconThemeData(color: darkTextLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryRed,
          side: const BorderSide(color: darkPrimaryRed),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
          textStyle: button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryRed,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          textStyle: button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: darkPrimaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: darkPrimaryRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: darkPrimaryRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        hintStyle: bodyMedium.copyWith(color: darkTextLight.withOpacity(0.5)),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2D2D2D),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
          side: const BorderSide(color: Color(0xFF404040)),
        ),
        margin: const EdgeInsets.all(spacingS),
      ),
      dividerTheme: DividerThemeData(
        color: const Color(0xFF404040),
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1A1A),
        selectedItemColor: darkPrimaryRed,
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
