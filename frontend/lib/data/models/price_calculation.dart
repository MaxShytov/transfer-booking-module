import 'package:json_annotation/json_annotation.dart';

import 'vehicle_class.dart';

part 'price_calculation.g.dart';

/// Applied extra fee in price calculation response.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class AppliedExtraFee {
  final String feeCode;
  final String feeName;
  final String feeType;
  final int quantity;
  @JsonKey(fromJson: _decimalFromJson)
  final double unitAmount;
  @JsonKey(fromJson: _decimalFromJson)
  final double totalAmount;

  const AppliedExtraFee({
    required this.feeCode,
    required this.feeName,
    required this.feeType,
    required this.quantity,
    required this.unitAmount,
    required this.totalAmount,
  });

  factory AppliedExtraFee.fromJson(Map<String, dynamic> json) =>
      _$AppliedExtraFeeFromJson(json);

  static double _decimalFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}

/// Price calculation response from API.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PriceCalculation {
  // Route info
  final String routeType;
  final String? routeName;
  @JsonKey(fromJson: _decimalFromJson)
  final double distanceKm;

  // Base price
  @JsonKey(fromJson: _decimalFromJson)
  final double basePrice;

  // Vehicle
  final VehicleClass? vehicleClass;
  @JsonKey(fromJson: _decimalFromJson)
  final double vehicleMultiplier;
  final String vehicleMultiplierLabel;

  // Seasonal
  @JsonKey(fromJson: _decimalFromJson)
  final double seasonalMultiplier;
  final String seasonalMultiplierLabel;

  // Passenger
  @JsonKey(fromJson: _decimalFromJson)
  final double passengerMultiplier;
  final String passengerMultiplierLabel;

  // Time
  @JsonKey(fromJson: _decimalFromJson)
  final double timeMultiplier;
  final String timeMultiplierLabel;

  // Subtotal
  @JsonKey(fromJson: _decimalFromJson)
  final double subtotal;

  // Round trip
  final bool isRoundTrip;
  @JsonKey(fromJson: _nullableDecimalFromJson)
  final double? roundTripMultiplier;
  final String? roundTripDiscountLabel;
  final String? returnDate;
  final String? returnTime;

  // Extra fees
  final List<AppliedExtraFee> extraFees;
  @JsonKey(fromJson: _decimalFromJson)
  final double extraFeesTotal;

  // Final
  @JsonKey(fromJson: _decimalFromJson)
  final double finalPrice;
  final String currency;

  // Breakdown visibility
  final bool showBreakdown;

  const PriceCalculation({
    required this.routeType,
    this.routeName,
    required this.distanceKm,
    required this.basePrice,
    this.vehicleClass,
    required this.vehicleMultiplier,
    required this.vehicleMultiplierLabel,
    required this.seasonalMultiplier,
    required this.seasonalMultiplierLabel,
    required this.passengerMultiplier,
    required this.passengerMultiplierLabel,
    required this.timeMultiplier,
    required this.timeMultiplierLabel,
    required this.subtotal,
    required this.isRoundTrip,
    this.roundTripMultiplier,
    this.roundTripDiscountLabel,
    this.returnDate,
    this.returnTime,
    required this.extraFees,
    required this.extraFeesTotal,
    required this.finalPrice,
    required this.currency,
    required this.showBreakdown,
  });

  factory PriceCalculation.fromJson(Map<String, dynamic> json) =>
      _$PriceCalculationFromJson(json);

  static double _decimalFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  static double? _nullableDecimalFromJson(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Check if this is a fixed route.
  bool get isFixedRoute => routeType == 'fixed_route';

  /// Get formatted final price.
  String get formattedFinalPrice => '€${finalPrice.toStringAsFixed(2)}';

  /// Get round trip discount percentage.
  int? get roundTripDiscountPercent {
    if (roundTripMultiplier == null) return null;
    return ((1 - roundTripMultiplier!) * 100).round();
  }
}
