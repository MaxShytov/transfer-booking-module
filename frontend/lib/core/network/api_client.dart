import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env_config.dart';
import '../storage/token_storage.dart';
import 'api_exceptions.dart';

/// Provider for the Dio HTTP client.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: EnvConfig.apiTimeout),
      receiveTimeout: const Duration(milliseconds: EnvConfig.apiTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add auth interceptor to attach JWT token
  dio.interceptors.add(_AuthInterceptor(ref.watch(tokenStorageProvider)));

  // Add logging interceptor in debug mode
  if (EnvConfig.enableLogging) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  // Add error handling interceptor
  dio.interceptors.add(_ErrorInterceptor());

  return dio;
});

/// Interceptor for adding JWT token to requests.
class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  _AuthInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for public endpoints
    final publicPaths = [
      '/auth/token/',
      '/auth/token/refresh/',
      '/auth/register/',
    ];
    if (publicPaths.any((path) => options.path.contains(path))) {
      return handler.next(options);
    }

    // Add token if available
    final token = await _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}

/// Interceptor for handling API errors.
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _mapDioExceptionToApiException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
      ),
    );
  }

  ApiException _mapDioExceptionToApiException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException.timeout();
      case DioExceptionType.connectionError:
        return const ApiException.noConnection();
      case DioExceptionType.badResponse:
        return _parseErrorResponse(err.response);
      case DioExceptionType.cancel:
        return const ApiException.cancelled();
      default:
        return ApiException.unknown(err.message ?? 'Unknown error');
    }
  }

  ApiException _parseErrorResponse(Response? response) {
    if (response == null) {
      return const ApiException.unknown('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Parse error message from response
    String? message;
    Map<String, List<String>> fieldErrors = {};

    if (data is Map<String, dynamic>) {
      // Handle Django REST Framework error format
      if (data.containsKey('message')) {
        message = data['message'] as String?;
      } else if (data.containsKey('detail')) {
        message = data['detail'] as String?;
      }

      // Parse field-level errors (DRF validation format)
      data.forEach((key, value) {
        if (key != 'message' && key != 'detail' && key != 'success') {
          if (value is List) {
            fieldErrors[key] = value.map((e) => e.toString()).toList();
          } else if (value is String) {
            fieldErrors[key] = [value];
          }
        }
      });

      // If no message but have field errors, build message from them
      if (message == null && fieldErrors.isNotEmpty) {
        final errorMessages = <String>[];
        fieldErrors.forEach((field, errors) {
          // Capitalize field name
          final fieldName = field.replaceAll('_', ' ');
          final capitalizedField = fieldName[0].toUpperCase() + fieldName.substring(1);
          for (final error in errors) {
            errorMessages.add('$capitalizedField: $error');
          }
        });
        message = errorMessages.join('\n');
      }
    }

    message ??= 'An error occurred';

    switch (statusCode) {
      case 400:
        return ApiException.badRequest(message, fieldErrors);
      case 401:
        return ApiException.unauthorized(message);
      case 403:
        return ApiException.forbidden(message);
      case 404:
        return ApiException.notFound(message);
      case 429:
        return ApiException.tooManyRequests(message);
      case >= 500:
        return ApiException.serverError(message);
      default:
        return ApiException.unknown(message);
    }
  }
}
