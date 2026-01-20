import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

/// Repository for authentication operations.
class AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepository({
    required Dio dio,
    required TokenStorage tokenStorage,
  })  : _dio = dio,
        _tokenStorage = tokenStorage;

  /// Login with email and password.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/token/',
      data: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);

    // Save tokens
    await _tokenStorage.saveTokens(
      accessToken: authResponse.access,
      refreshToken: authResponse.refresh,
    );

    // Fetch user data
    return getCurrentUser();
  }

  /// Register a new user.
  Future<UserModel> register({
    required String email,
    required String password,
    required String passwordConfirm,
    String? firstName,
    String? lastName,
    String? phone,
    String language = 'en',
  }) async {
    final response = await _dio.post(
      '/auth/register/',
      data: {
        'email': email,
        'password': password,
        'password_confirm': passwordConfirm,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        'language': language,
      },
    );

    final registrationResponse = RegistrationResponse.fromJson(response.data);

    // Save tokens
    await _tokenStorage.saveTokens(
      accessToken: registrationResponse.data.tokens.access,
      refreshToken: registrationResponse.data.tokens.refresh,
    );

    return registrationResponse.data.user;
  }

  /// Get current user.
  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get('/auth/me/');
    final meResponse = MeResponse.fromJson(response.data);
    return meResponse.data;
  }

  /// Update user profile.
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? language,
  }) async {
    final response = await _dio.patch(
      '/auth/me/',
      data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (language != null) 'language': language,
      },
    );

    final meResponse = MeResponse.fromJson(response.data);
    return meResponse.data;
  }

  /// Change password.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    await _dio.post(
      '/auth/change-password/',
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirm': newPasswordConfirm,
      },
    );
  }

  /// Logout.
  Future<void> logout() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _dio.post(
          '/auth/logout/',
          data: {'refresh': refreshToken},
        );
      }
    } finally {
      await _tokenStorage.clearTokens();
    }
  }

  /// Check if user is logged in.
  Future<bool> isLoggedIn() async {
    return _tokenStorage.hasTokens();
  }

  /// Refresh access token.
  Future<void> refreshToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _dio.post(
      '/auth/token/refresh/',
      data: {'refresh': refreshToken},
    );

    final newAccessToken = response.data['access'] as String;
    await _tokenStorage.saveAccessToken(newAccessToken);
  }
}
