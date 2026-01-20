import 'package:json_annotation/json_annotation.dart';

part 'price_breakdown.g.dart';

/// Price calculation result with full breakdown.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PriceBreakdown {
  /// Type of pricing: 'fixed_route' or 'distance_based'
  final String pricingType;

  /// Base price before multipliers.
  final double basePrice;

  /// Route name if fixed route.
  final String? routeName;

  /// Distance in km if distance-based.
  final double? distanceKm;

  /// Vehicle class multiplier applied.
  final double vehicleMultiplier;

  /// Vehicle class name.
  final String vehicleClassName;

  /// Passenger count multiplier applied.
  final double passengerMultiplier;

  /// Number of passengers.
  final int passengerCount;

  /// Seasonal multiplier applied.
  final double seasonalMultiplier;

  /// Season name.
  final String? seasonName;

  /// Time slot multiplier applied.
  final double timeMultiplier;

  /// Time slot name (e.g., "Night", "Standard").
  final String? timeSlotName;

  /// Subtotal after all multipliers.
  final double subtotal;

  /// List of extra fees applied.
  final List<ExtraFeeItem> extraFees;

  /// Total of all extra fees.
  final double extraFeesTotal;

  /// Final price (subtotal + extra fees).
  final double finalPrice;

  /// Currency code.
  final String currency;

  const PriceBreakdown({
    required this.pricingType,
    required this.basePrice,
    this.routeName,
    this.distanceKm,
    required this.vehicleMultiplier,
    required this.vehicleClassName,
    required this.passengerMultiplier,
    required this.passengerCount,
    required this.seasonalMultiplier,
    this.seasonName,
    required this.timeMultiplier,
    this.timeSlotName,
    required this.subtotal,
    required this.extraFees,
    required this.extraFeesTotal,
    required this.finalPrice,
    this.currency = 'EUR',
  });

  factory PriceBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PriceBreakdownFromJson(json);

  /// Check if this is a fixed route pricing.
  bool get isFixedRoute => pricingType == 'fixed_route';

  /// Check if this is distance-based pricing.
  bool get isDistanceBased => pricingType == 'distance_based';

  /// Combined multiplier (all multipliers multiplied together).
  double get combinedMultiplier =>
      vehicleMultiplier * passengerMultiplier * seasonalMultiplier * timeMultiplier;
}

/// Individual extra fee item.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ExtraFeeItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final double total;

  const ExtraFeeItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory ExtraFeeItem.fromJson(Map<String, dynamic> json) =>
      _$ExtraFeeItemFromJson(json);
}
