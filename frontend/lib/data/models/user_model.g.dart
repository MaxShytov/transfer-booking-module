// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: UserModel._idFromJson(json['id']),
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  phone: json['phone'] as String?,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  language: $enumDecode(_$UserLanguageEnumMap, json['language']),
  isActive: json['is_active'] as bool,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.manager: 'manager',
  UserRole.driver: 'driver',
  UserRole.customer: 'customer',
};

const _$UserLanguageEnumMap = {
  UserLanguage.en: 'en',
  UserLanguage.it: 'it',
  UserLanguage.de: 'de',
  UserLanguage.fr: 'fr',
  UserLanguage.ar: 'ar',
};
