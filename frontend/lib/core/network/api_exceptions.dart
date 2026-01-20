import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exceptions.freezed.dart';

/// Represents API errors that can occur during network requests.
@freezed
class ApiException with _$ApiException implements Exception {
  const ApiException._();

  /// Request validation failed (400).
  const factory ApiException.badRequest(
    String message,
    Map<String, List<String>> fieldErrors,
  ) = BadRequestException;

  /// Authentication required (401).
  const factory ApiException.unauthorized(String message) =
      UnauthorizedException;

  /// Access denied (403).
  const factory ApiException.forbidden(String message) = ForbiddenException;

  /// Resource not found (404).
  const factory ApiException.notFound(String message) = NotFoundException;

  /// Rate limit exceeded (429).
  const factory ApiException.tooManyRequests(String message) =
      TooManyRequestsException;

  /// Server error (5xx).
  const factory ApiException.serverError(String message) = ServerErrorException;

  /// No internet connection.
  const factory ApiException.noConnection() = NoConnectionException;

  /// Request timeout.
  const factory ApiException.timeout() = TimeoutException;

  /// Request cancelled.
  const factory ApiException.cancelled() = CancelledException;

  /// Unknown error.
  const factory ApiException.unknown(String message) = UnknownException;

  /// Returns a user-friendly error message.
  String get userMessage => when(
        badRequest: (message, _) => message,
        unauthorized: (message) => message,
        forbidden: (message) => message,
        notFound: (message) => message,
        tooManyRequests: (_) => 'Too many attempts. Please try again later.',
        serverError: (_) => 'Server error. Please try again later.',
        noConnection: () => 'No internet connection. Please check your network.',
        timeout: () => 'Request timed out. Please try again.',
        cancelled: () => 'Request was cancelled.',
        unknown: (message) => message,
      );

  /// Returns field-level errors if available.
  Map<String, List<String>> get fieldErrors => maybeWhen(
        badRequest: (_, errors) => errors,
        orElse: () => {},
      );
}
