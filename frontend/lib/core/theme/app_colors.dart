import 'package:flutter/material.dart';

/// 8Move Transfer brand colors.
///
/// Blue/teal theme for travel/transfer service.
class AppColors {
  AppColors._();

  // ============================================
  // Primary Brand Colors (8Move Transfer)
  // ============================================

  /// Main brand color - Mediterranean blue.
  static const Color primary = Color(0xFF0077B6);

  /// Light variant for gradients.
  static const Color primaryLight = Color(0xFF00A8E8);

  /// Dark variant for depth.
  static const Color primaryDark = Color(0xFF005F8C);

  /// Accent color - sunset orange.
  static const Color accent = Color(0xFFFF6B35);

  /// Primary gradient for CTAs.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Horizontal gradient for buttons.
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ============================================
  // Background Colors
  // ============================================

  /// Light background.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// White background.
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  /// Card background.
  static const Color backgroundCard = Color(0xFFFFFFFF);

  /// Dark background (for dark mode).
  static const Color backgroundDark = Color(0xFF1A1A2E);

  /// Dark card background.
  static const Color backgroundDarkCard = Color(0xFF16213E);

  // ============================================
  // Text Colors
  // ============================================

  /// Primary text.
  static const Color textPrimary = Color(0xFF1E293B);

  /// Secondary text.
  static const Color textSecondary = Color(0xFF64748B);

  /// Hint text.
  static const Color textHint = Color(0xFF94A3B8);

  /// Text on dark backgrounds.
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Secondary text on dark.
  static const Color textSecondaryOnDark = Color(0xB3FFFFFF);

  // ============================================
  // UI Element Colors
  // ============================================

  /// Border color.
  static const Color border = Color(0xFFE2E8F0);

  /// Focused border.
  static const Color borderFocused = Color(0xFF0077B6);

  /// Divider color.
  static const Color divider = Color(0xFFE2E8F0);

  /// Error color.
  static const Color error = Color(0xFFDC2626);

  /// Error background.
  static const Color errorBackground = Color(0xFFFEE2E2);

  /// Success color.
  static const Color success = Color(0xFF16A34A);

  /// Success background.
  static const Color successBackground = Color(0xFFDCFCE7);

  /// Warning color.
  static const Color warning = Color(0xFFF59E0B);

  /// Warning background.
  static const Color warningBackground = Color(0xFFFEF3C7);

  /// Disabled state.
  static const Color disabled = Color(0xFF9CA3AF);

  // ============================================
  // Role-specific Colors
  // ============================================

  /// Admin role color.
  static const Color roleAdmin = Color(0xFF7C3AED);

  /// Manager role color.
  static const Color roleManager = Color(0xFF2563EB);

  /// Driver role color.
  static const Color roleDriver = Color(0xFF059669);

  /// Customer role color.
  static const Color roleCustomer = Color(0xFF6B7280);

  // ============================================
  // Price Calculator Colors
  // ============================================

  /// Base price color.
  static const Color priceBase = Color(0xFF0077B6);

  /// Multiplier color.
  static const Color priceMultiplier = Color(0xFF7C3AED);

  /// Extra fee color.
  static const Color priceExtra = Color(0xFFEA580C);

  /// Final price color.
  static const Color priceFinal = Color(0xFF16A34A);
}
