// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixed_route.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FixedRoute _$FixedRouteFromJson(Map<String, dynamic> json) => FixedRoute(
  id: (json['id'] as num).toInt(),
  routeName: json['route_name'] as String,
  pickupAddress: json['pickup_address'] as String,
  pickupLat: FixedRoute._decimalFromJson(json['pickup_lat']),
  pickupLng: FixedRoute._decimalFromJson(json['pickup_lng']),
  pickupType: $enumDecode(_$LocationTypeEnumMap, json['pickup_type']),
  pickupTypeDisplay: json['pickup_type_display'] as String?,
  pickupRadiusKm: FixedRoute._decimalFromJson(json['pickup_radius_km']),
  dropoffAddress: json['dropoff_address'] as String,
  dropoffLat: FixedRoute._decimalFromJson(json['dropoff_lat']),
  dropoffLng: FixedRoute._decimalFromJson(json['dropoff_lng']),
  dropoffType: $enumDecode(_$LocationTypeEnumMap, json['dropoff_type']),
  dropoffTypeDisplay: json['dropoff_type_display'] as String?,
  dropoffRadiusKm: FixedRoute._decimalFromJson(json['dropoff_radius_km']),
  basePrice: FixedRoute._decimalFromJson(json['base_price']),
  currency: json['currency'] as String,
  distanceKm: FixedRoute._nullableDecimalFromJson(json['distance_km']),
);

const _$LocationTypeEnumMap = {
  LocationType.airport: 'airport',
  LocationType.cityCenter: 'city_center',
  LocationType.hotelZone: 'hotel_zone',
  LocationType.resort: 'resort',
  LocationType.exactAddress: 'exact_address',
};

RouteMatchResponse _$RouteMatchResponseFromJson(Map<String, dynamic> json) =>
    RouteMatchResponse(
      matched: json['matched'] as bool,
      routeType: json['route_type'] as String,
      route: json['route'] == null
          ? null
          : FixedRoute.fromJson(json['route'] as Map<String, dynamic>),
      distanceKm: RouteMatchResponse._decimalFromJson(json['distance_km']),
      distanceRule: json['distance_rule'] == null
          ? null
          : DistancePricingRule.fromJson(
              json['distance_rule'] as Map<String, dynamic>,
            ),
      basePrice: RouteMatchResponse._decimalFromJson(json['base_price']),
    );

DistancePricingRule _$DistancePricingRuleFromJson(Map<String, dynamic> json) =>
    DistancePricingRule(
      id: (json['id'] as num).toInt(),
      ruleName: json['rule_name'] as String,
      baseRate: DistancePricingRule._decimalFromJson(json['base_rate']),
      pricePerKm: DistancePricingRule._decimalFromJson(json['price_per_km']),
      pricePerMinute: DistancePricingRule._decimalFromJson(
        json['price_per_minute'],
      ),
      minDistanceKm: (json['min_distance_km'] as num).toInt(),
      maxDistanceKm: (json['max_distance_km'] as num).toInt(),
      priority: (json['priority'] as num).toInt(),
    );
