import 'package:json_annotation/json_annotation.dart';

part 'fixed_route.g.dart';

/// Location type enum.
enum LocationType {
  @JsonValue('airport')
  airport,
  @JsonValue('city_center')
  cityCenter,
  @JsonValue('hotel_zone')
  hotelZone,
  @JsonValue('resort')
  resort,
  @JsonValue('exact_address')
  exactAddress,
}

/// Fixed route model for API responses.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class FixedRoute {
  final int id;
  final String routeName;
  final String pickupAddress;
  @JsonKey(fromJson: _decimalFromJson)
  final double pickupLat;
  @JsonKey(fromJson: _decimalFromJson)
  final double pickupLng;
  final LocationType pickupType;
  final String? pickupTypeDisplay;
  @JsonKey(fromJson: _decimalFromJson)
  final double pickupRadiusKm;
  final String dropoffAddress;
  @JsonKey(fromJson: _decimalFromJson)
  final double dropoffLat;
  @JsonKey(fromJson: _decimalFromJson)
  final double dropoffLng;
  final LocationType dropoffType;
  final String? dropoffTypeDisplay;
  @JsonKey(fromJson: _decimalFromJson)
  final double dropoffRadiusKm;
  @JsonKey(fromJson: _decimalFromJson)
  final double basePrice;
  final String currency;
  @JsonKey(fromJson: _nullableDecimalFromJson)
  final double? distanceKm;

  const FixedRoute({
    required this.id,
    required this.routeName,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.pickupType,
    this.pickupTypeDisplay,
    required this.pickupRadiusKm,
    required this.dropoffAddress,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.dropoffType,
    this.dropoffTypeDisplay,
    required this.dropoffRadiusKm,
    required this.basePrice,
    required this.currency,
    this.distanceKm,
  });

  factory FixedRoute.fromJson(Map<String, dynamic> json) =>
      _$FixedRouteFromJson(json);

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
}

/// Route match response.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class RouteMatchResponse {
  final bool matched;
  final String routeType;
  final FixedRoute? route;
  @JsonKey(fromJson: _decimalFromJson)
  final double distanceKm;
  final DistancePricingRule? distanceRule;
  @JsonKey(fromJson: _decimalFromJson)
  final double basePrice;

  const RouteMatchResponse({
    required this.matched,
    required this.routeType,
    this.route,
    required this.distanceKm,
    this.distanceRule,
    required this.basePrice,
  });

  factory RouteMatchResponse.fromJson(Map<String, dynamic> json) =>
      _$RouteMatchResponseFromJson(json);

  static double _decimalFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}

/// Distance pricing rule model.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class DistancePricingRule {
  final int id;
  final String ruleName;
  @JsonKey(fromJson: _decimalFromJson)
  final double baseRate;
  @JsonKey(fromJson: _decimalFromJson)
  final double pricePerKm;
  @JsonKey(fromJson: _decimalFromJson)
  final double pricePerMinute;
  final int minDistanceKm;
  final int maxDistanceKm;
  final int priority;

  const DistancePricingRule({
    required this.id,
    required this.ruleName,
    required this.baseRate,
    required this.pricePerKm,
    required this.pricePerMinute,
    required this.minDistanceKm,
    required this.maxDistanceKm,
    required this.priority,
  });

  factory DistancePricingRule.fromJson(Map<String, dynamic> json) =>
      _$DistancePricingRuleFromJson(json);

  static double _decimalFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}
