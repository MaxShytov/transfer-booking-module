import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/generated/app_localizations.dart';

/// Extension to easily access localized strings from BuildContext.
extension L10nExtension on BuildContext {
  /// Returns the AppLocalizations instance for this context.
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// List of supported locales in the app.
const supportedLocales = [
  Locale('en'), // English (default)
  Locale('it'), // Italian
  Locale('de'), // German
  Locale('fr'), // French
  Locale('ar'), // Arabic (RTL)
];

/// Check if the given locale is RTL (right-to-left).
bool isRtlLocale(Locale locale) {
  return locale.languageCode == 'ar';
}

/// Get locale from language code string.
Locale getLocaleFromCode(String code) {
  return supportedLocales.firstWhere(
    (locale) => locale.languageCode == code,
    orElse: () => const Locale('en'),
  );
}

const _localeKey = 'app_locale';

/// Provider for managing app locale.
/// Returns null to use device locale, or a specific Locale if user selected one.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// Notifier for locale state management.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localeKey);
    if (savedCode != null) {
      state = getLocaleFromCode(savedCode);
    }
    // If null, Flutter will use device locale automatically
  }

  /// Set locale manually. Pass null to revert to device locale.
  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString(_localeKey, locale.languageCode);
    } else {
      await prefs.remove(_localeKey);
    }
    state = locale;
  }

  /// Reset to device locale.
  Future<void> useDeviceLocale() async {
    await setLocale(null);
  }
}
