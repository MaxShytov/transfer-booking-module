import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Provider for authentication state.
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.watch(authRepositoryProvider));
});

/// Notifier for authentication state.
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthStateNotifier(this._authRepository) : super(const AuthState.initial());

  /// Check initial auth state.
  Future<void> checkAuthState() async {
    state = const AuthState.loading();

    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getCurrentUser();
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Login with email and password.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        state = AuthState.error(apiError.userMessage);
      } else {
        state = AuthState.error(e.message ?? 'Login failed');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Register a new user.
  Future<void> register({
    required String email,
    required String password,
    required String passwordConfirm,
    String? firstName,
    String? lastName,
    String? phone,
    String language = 'en',
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _authRepository.register(
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        language: language,
      );
      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        state = AuthState.error(apiError.userMessage);
      } else {
        state = AuthState.error(e.message ?? 'Registration failed');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Update user profile.
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? language,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    try {
      final updatedUser = await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        language: language,
      );
      state = AuthState.authenticated(updatedUser);
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        state = AuthState.error(apiError.userMessage);
      } else {
        state = AuthState.error(e.message ?? 'Update failed');
      }
      // Restore previous state
      state = AuthState.authenticated(currentUser);
    }
  }

  /// Logout.
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } finally {
      state = const AuthState.unauthenticated();
    }
  }

  /// Clear error state.
  void clearError() {
    if (state is AuthStateError) {
      state = const AuthState.unauthenticated();
    }
  }
}
