// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  access: json['access'] as String,
  refresh: json['refresh'] as String,
);

RegistrationResponse _$RegistrationResponseFromJson(
  Map<String, dynamic> json,
) => RegistrationResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: RegistrationData.fromJson(json['data'] as Map<String, dynamic>),
);

RegistrationData _$RegistrationDataFromJson(Map<String, dynamic> json) =>
    RegistrationData(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: TokensData.fromJson(json['tokens'] as Map<String, dynamic>),
    );

TokensData _$TokensDataFromJson(Map<String, dynamic> json) => TokensData(
  refresh: json['refresh'] as String,
  access: json['access'] as String,
);

MeResponse _$MeResponseFromJson(Map<String, dynamic> json) => MeResponse(
  success: json['success'] as bool,
  data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
);
