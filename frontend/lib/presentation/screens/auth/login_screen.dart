import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auth_state.dart';
import '../../widgets/atoms/app_text_field.dart';
import '../../widgets/atoms/gradient_button.dart';
import '../../widgets/molecules/password_field.dart';

/// Login screen with Cupertino style.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _emailError = Validators.validateEmail(_emailController.text.trim());
      _passwordError = Validators.validatePassword(_passwordController.text);
    });
  }

  Future<void> _handleLogin() async {
    _validateFields();
    if (_emailError != null || _passwordError != null) return;

    await ref.read(authStateProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
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
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(context.l10n.loginError),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text(context.l10n.ok),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
          ref.read(authStateProvider.notifier).clearError();
        },
      );
    });

    final isLoading = authState.isLoading;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.login),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingXl),

                // Logo
                Center(
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    height: 80,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                Text(
                  context.l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemBlue,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXxl),

                // Email field
                AppTextField(
                  label: context.l10n.email,
                  hint: context.l10n.emailHint,
                  errorText: _emailError,
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  onChanged: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                  onSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Password field
                PasswordField(
                  label: context.l10n.password,
                  hint: context.l10n.passwordHint,
                  errorText: _passwordError,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: AppDimensions.spacingXl),

                // Login button
                GradientButton(
                  text: context.l10n.login,
                  onPressed: isLoading ? null : _handleLogin,
                  isLoading: isLoading,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.noAccount,
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: isLoading ? null : () => context.go('/register'),
                      child: Text(context.l10n.register),
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
