import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'auth_response.g.dart';

/// Response from login endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class AuthResponse {
  final String access;
  final String refresh;

  const AuthResponse({
    required this.access,
    required this.refresh,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// Response from registration endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class RegistrationResponse {
  final bool success;
  final String message;
  final RegistrationData data;

  const RegistrationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class RegistrationData {
  final UserModel user;
  final TokensData tokens;

  const RegistrationData({
    required this.user,
    required this.tokens,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) =>
      _$RegistrationDataFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class TokensData {
  final String refresh;
  final String access;

  const TokensData({
    required this.refresh,
    required this.access,
  });

  factory TokensData.fromJson(Map<String, dynamic> json) =>
      _$TokensDataFromJson(json);
}

/// Response from /me endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class MeResponse {
  final bool success;
  final UserModel data;

  const MeResponse({
    required this.success,
    required this.data,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) =>
      _$MeResponseFromJson(json);
}
