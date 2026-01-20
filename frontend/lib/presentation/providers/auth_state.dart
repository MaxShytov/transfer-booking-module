import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/user_model.dart';

part 'auth_state.freezed.dart';

/// Authentication state.
@freezed
class AuthState with _$AuthState {
  const AuthState._();

  /// Initial state - checking auth status.
  const factory AuthState.initial() = AuthStateInitial;

  /// Loading state.
  const factory AuthState.loading() = AuthStateLoading;

  /// Authenticated state with user data.
  const factory AuthState.authenticated(UserModel user) = AuthStateAuthenticated;

  /// Unauthenticated state.
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;

  /// Error state.
  const factory AuthState.error(String message) = AuthStateError;

  /// Get user if authenticated.
  UserModel? get user => maybeWhen(
        authenticated: (user) => user,
        orElse: () => null,
      );

  /// Check if authenticated.
  bool get isAuthenticated => this is AuthStateAuthenticated;

  /// Check if loading.
  bool get isLoading => this is AuthStateLoading;

  /// Check if explicitly unauthenticated (used for router redirect).
  bool get isUnauthenticated => this is AuthStateUnauthenticated;
}
