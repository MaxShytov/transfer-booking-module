import 'package:json_annotation/json_annotation.dart';

part 'extra_fee.g.dart';

/// Fee type enum.
enum FeeType {
  @JsonValue('flat')
  flat,
  @JsonValue('per_item')
  perItem,
  @JsonValue('percentage')
  percentage,
}

/// Extra fee model for API responses.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExtraFee {
  final int id;
  final String feeName;
  final String feeCode;
  final FeeType feeType;
  final String? feeTypeDisplay;
  @JsonKey(fromJson: _decimalFromJson)
  final double amount;
  final bool isOptional;
  final int displayOrder;
  final String description;

  const ExtraFee({
    required this.id,
    required this.feeName,
    required this.feeCode,
    required this.feeType,
    this.feeTypeDisplay,
    required this.amount,
    required this.isOptional,
    required this.displayOrder,
    required this.description,
  });

  factory ExtraFee.fromJson(Map<String, dynamic> json) =>
      _$ExtraFeeFromJson(json);

  static double _decimalFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  /// Calculate fee for given quantity.
  double calculateFee({int quantity = 1, double? basePrice}) {
    switch (feeType) {
      case FeeType.perItem:
        return amount * quantity;
      case FeeType.percentage:
        return basePrice != null ? (amount / 100) * basePrice : 0;
      case FeeType.flat:
      default:
        return amount;
    }
  }

  /// Get formatted price string.
  String get formattedPrice {
    switch (feeType) {
      case FeeType.perItem:
        return '€${amount.toStringAsFixed(2)}/item';
      case FeeType.percentage:
        return '${amount.toStringAsFixed(0)}%';
      case FeeType.flat:
      default:
        return '€${amount.toStringAsFixed(2)}';
    }
  }
}
