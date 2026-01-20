import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/generated/app_localizations.dart';

import 'core/l10n/l10n_extension.dart' show supportedLocales, localeProvider;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cupertino_theme.dart';
import 'presentation/providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TransferBookingApp(),
    ),
  );
}

/// Main app widget.
class TransferBookingApp extends ConsumerStatefulWidget {
  const TransferBookingApp({super.key});

  @override
  ConsumerState<TransferBookingApp> createState() => _TransferBookingAppState();
}

class _TransferBookingAppState extends ConsumerState<TransferBookingApp> {
  @override
  void initState() {
    super.initState();
    // Check auth state on app start
    Future.microtask(() {
      ref.read(authStateProvider.notifier).checkAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final selectedLocale = ref.watch(localeProvider);

    return PlatformProvider(
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: false,
        iosUseZeroPaddingForAppbarPlatformIcon: true,
      ),
      builder: (context) => PlatformTheme(
        themeMode: ThemeMode.light,
        materialLightTheme: AppTheme.light,
        materialDarkTheme: AppTheme.dark,
        cupertinoLightTheme: AppCupertinoTheme.light,
        cupertinoDarkTheme: AppCupertinoTheme.dark,
        builder: (context) => PlatformApp.router(
          title: '8Move Transfer',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          // If user selected a locale, use it; otherwise Flutter uses device locale
          locale: selectedLocale,
          routerConfig: router,
        ),
      ),
    );
  }
}
