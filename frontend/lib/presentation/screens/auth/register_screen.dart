import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';
import '../../widgets/atoms/app_text_field.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/molecules/password_field.dart';

/// Registration screen.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authStateProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirm: _passwordConfirmController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Listen for auth state changes
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      next.whenOrNull(
        authenticated: (_) {
          context.go('/');
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
          // Clear only password fields on error, stay on this screen
          _passwordController.clear();
          _passwordConfirmController.clear();
        },
      );
    });

    final isLoading = authState.isLoading;

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createAccount),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // First Name
                AppTextField(
                  label: l10n.firstName,
                  hint: l10n.firstNameHint,
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: (value) =>
                      Validators.validateRequired(value, l10n.firstName),
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Last Name
                AppTextField(
                  label: l10n.lastName,
                  hint: l10n.lastNameHint,
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: (value) =>
                      Validators.validateRequired(value, l10n.lastName),
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Email
                AppTextField(
                  label: l10n.email,
                  hint: l10n.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Phone (optional)
                AppTextField(
                  label: l10n.phoneOptional,
                  hint: l10n.phoneHint,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Password
                PasswordField(
                  label: l10n.password,
                  hint: l10n.passwordMinChars,
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Confirm Password
                PasswordField(
                  label: l10n.confirmPassword,
                  hint: l10n.confirmPasswordHint,
                  controller: _passwordConfirmController,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  validator: (value) => Validators.validatePasswordConfirm(
                    value,
                    _passwordController.text,
                  ),
                  onSubmitted: (_) => _handleRegister(),
                ),
                const SizedBox(height: AppDimensions.spacingXl),

                // Register button
                GradientButton(
                  text: l10n.createAccount,
                  onPressed: isLoading ? null : _handleRegister,
                  isLoading: isLoading,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : () => context.go('/login'),
                      child: Text(l10n.login),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
