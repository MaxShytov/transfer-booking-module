import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User roles in the system.
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('manager')
  manager,
  @JsonValue('driver')
  driver,
  @JsonValue('customer')
  customer,
}

/// Supported languages.
enum UserLanguage {
  @JsonValue('en')
  en,
  @JsonValue('it')
  it,
  @JsonValue('de')
  de,
  @JsonValue('fr')
  fr,
  @JsonValue('ar')
  ar,
}

/// User model for API responses.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UserModel {
  @JsonKey(fromJson: _idFromJson)
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final UserRole role;
  final UserLanguage language;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
    required this.language,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert id from dynamic (int or String) to String.
  static String _idFromJson(dynamic id) => id.toString();

  /// Full name.
  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : email;
  }

  /// Check if user is admin.
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is manager.
  bool get isManager => role == UserRole.manager;

  /// Check if user is driver.
  bool get isDriver => role == UserRole.driver;

  /// Check if user is customer.
  bool get isCustomer => role == UserRole.customer;

  /// Check if user can see detailed price breakdown.
  bool get canSeeDetailedPricing => isAdmin || isManager;
}
