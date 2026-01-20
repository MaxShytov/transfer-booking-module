import 'package:flutter/cupertino.dart';

/// Cupertino theme configuration for iOS/macOS style.
class AppCupertinoTheme {
  AppCupertinoTheme._();

  /// Light Cupertino theme (macOS Tahoe inspired).
  static CupertinoThemeData get light => const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
        primaryContrastingColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        barBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Color(0xF0F9F9F9),
          darkColor: Color(0xF01D1D1D),
        ),
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.systemBlue,
          textStyle: TextStyle(
            fontSize: 17,
            color: CupertinoColors.label,
            fontFamily: '.SF Pro Text',
          ),
          navTitleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.label,
            fontFamily: '.SF Pro Text',
          ),
          navLargeTitleTextStyle: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.label,
            fontFamily: '.SF Pro Display',
          ),
          actionTextStyle: TextStyle(
            fontSize: 17,
            color: CupertinoColors.systemBlue,
            fontFamily: '.SF Pro Text',
          ),
        ),
      );

  /// Dark Cupertino theme.
  static CupertinoThemeData get dark => const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.systemBlue,
        primaryContrastingColor: CupertinoColors.white,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
        barBackgroundColor: CupertinoDynamicColor.withBrightness(
          color: Color(0xF0F9F9F9),
          darkColor: Color(0xF01D1D1D),
        ),
        textTheme: CupertinoTextThemeData(
          primaryColor: CupertinoColors.systemBlue,
          textStyle: TextStyle(
            fontSize: 17,
            color: CupertinoColors.label,
            fontFamily: '.SF Pro Text',
          ),
        ),
      );

  // ============================================
  // Custom Colors for iOS Style
  // ============================================

  /// System grouped background (light gray).
  static const Color groupedBackground = CupertinoColors.systemGroupedBackground;

  /// Secondary grouped background (white sections).
  static const Color secondaryGroupedBackground =
      CupertinoColors.secondarySystemGroupedBackground;

  /// Separator color.
  static const Color separator = CupertinoColors.separator;

  /// System fill (for text fields).
  static const Color systemFill = CupertinoColors.systemFill;

  /// Tertiary system fill.
  static const Color tertiarySystemFill = CupertinoColors.tertiarySystemFill;

  // ============================================
  // Decorations
  // ============================================

  /// iOS-style card decoration with subtle shadow.
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      );

  /// Grouped list section decoration.
  static BoxDecoration get groupedSectionDecoration => const BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      );

  /// Text field decoration.
  static BoxDecoration get textFieldDecoration => BoxDecoration(
        color: CupertinoColors.tertiarySystemFill,
        borderRadius: BorderRadius.circular(10),
      );
}
