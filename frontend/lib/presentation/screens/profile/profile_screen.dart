import 'package:flutter/cupertino.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';

/// Profile screen showing user info and logout - Cupertino style.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.profile),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.spacingXl),

              // Avatar
              _buildAvatar(user),
              const SizedBox(height: AppDimensions.spacingLg),

              // Name
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),

              // Email
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),

              // Role badge
              _buildRoleBadge(user.role, l10n),
              const SizedBox(height: AppDimensions.spacingXxl),

              // Info list
              CupertinoListSection.insetGrouped(
                children: [
                  CupertinoListTile.notched(
                    leading: const Icon(CupertinoIcons.phone),
                    title: Text(l10n.phone),
                    additionalInfo: Text(
                      user.phone?.isNotEmpty == true ? user.phone! : l10n.notSet,
                    ),
                  ),
                  CupertinoListTile.notched(
                    leading: const Icon(CupertinoIcons.globe),
                    title: Text(l10n.language),
                    additionalInfo: Text(_getCurrentLanguageName(context, ref, l10n)),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => _showLanguagePicker(context, ref, l10n),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingXl),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.systemRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  onPressed: () => _handleLogout(context, ref, l10n),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.square_arrow_right,
                        color: CupertinoColors.systemRed,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.logout,
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserModel user) {
    final initial = user.firstName.isNotEmpty
        ? user.firstName[0].toUpperCase()
        : user.email[0].toUpperCase();

    return Container(
      width: AppDimensions.avatarLg,
      height: AppDimensions.avatarLg,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(UserRole role, AppLocalizations l10n) {
    Color color;
    String label;

    switch (role) {
      case UserRole.admin:
        color = AppColors.roleAdmin;
        label = l10n.roleAdmin;
        break;
      case UserRole.manager:
        color = AppColors.roleManager;
        label = l10n.roleManager;
        break;
      case UserRole.driver:
        color = AppColors.roleDriver;
        label = l10n.roleDriver;
        break;
      case UserRole.customer:
        color = AppColors.roleCustomer;
        label = l10n.roleCustomer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
        vertical: AppDimensions.paddingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  String _getCurrentLanguageName(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final selectedLocale = ref.watch(localeProvider);
    if (selectedLocale == null) {
      return l10n.systemDefault;
    }
    return _getLanguageNameFromCode(selectedLocale.languageCode, l10n);
  }

  String _getLanguageNameFromCode(String code, AppLocalizations l10n) {
    switch (code) {
      case 'en':
        return l10n.langEnglish;
      case 'it':
        return l10n.langItalian;
      case 'de':
        return l10n.langGerman;
      case 'fr':
        return l10n.langFrench;
      case 'ar':
        return l10n.langArabic;
      default:
        return l10n.langEnglish;
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final selectedLocale = ref.read(localeProvider);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(l10n.selectLanguage),
        actions: [
          // System default option
          CupertinoActionSheetAction(
            onPressed: () {
              ref.read(localeProvider.notifier).useDeviceLocale();
              Navigator.pop(ctx);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.systemDefault),
                if (selectedLocale == null) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    CupertinoIcons.checkmark,
                    size: 18,
                    color: CupertinoColors.systemBlue,
                  ),
                ],
              ],
            ),
          ),
          // Language options
          ...supportedLocales.map((locale) {
            final isSelected = selectedLocale?.languageCode == locale.languageCode;
            return CupertinoActionSheetAction(
              onPressed: () {
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.pop(ctx);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_getLanguageNameFromCode(locale.languageCode, l10n)),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      CupertinoIcons.checkmark,
                      size: 18,
                      color: CupertinoColors.systemBlue,
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }
}
