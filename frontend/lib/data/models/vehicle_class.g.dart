// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleClass _$VehicleClassFromJson(Map<String, dynamic> json) => VehicleClass(
  id: (json['id'] as num).toInt(),
  className: json['class_name'] as String,
  classCode: json['class_code'] as String,
  tierLevel: (json['tier_level'] as num).toInt(),
  priceMultiplier: VehicleClass._decimalFromJson(json['price_multiplier']),
  maxPassengers: (json['max_passengers'] as num).toInt(),
  maxLargeLuggage: (json['max_large_luggage'] as num).toInt(),
  maxSmallLuggage: (json['max_small_luggage'] as num).toInt(),
  description: json['description'] as String,
  exampleVehicles: json['example_vehicles'] as String,
  iconUrl: json['icon_url'] as String?,
  displayOrder: (json['display_order'] as num).toInt(),
);

AvailableVehiclesResponse _$AvailableVehiclesResponseFromJson(
  Map<String, dynamic> json,
) => AvailableVehiclesResponse(
  minTier: (json['min_tier'] as num).toInt(),
  passengerTier: (json['passenger_tier'] as num).toInt(),
  luggageTier: (json['luggage_tier'] as num).toInt(),
  availableClasses: (json['available_classes'] as List<dynamic>)
      .map((e) => VehicleClass.fromJson(e as Map<String, dynamic>))
      .toList(),
);
