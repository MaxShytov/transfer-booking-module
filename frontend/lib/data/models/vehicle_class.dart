import 'package:json_annotation/json_annotation.dart';

part 'vehicle_class.g.dart';

/// Vehicle class model for API responses.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class VehicleClass {
  final int id;
  final String className;
  final String classCode;
  final int tierLevel;
  @JsonKey(fromJson: _decimalFromJson)
  final double priceMultiplier;
  final int maxPassengers;
  final int maxLargeLuggage;
  final int maxSmallLuggage;
  final String description;
  final String exampleVehicles;
  final String? iconUrl;
  final int displayOrder;

  const VehicleClass({
    required this.id,
    required this.className,
    required this.classCode,
    required this.tierLevel,
    required this.priceMultiplier,
    required this.maxPassengers,
    required this.maxLargeLuggage,
    required this.maxSmallLuggage,
    required this.description,
    required this.exampleVehicles,
    this.iconUrl,
    required this.displayOrder,
  });

  factory VehicleClass.fromJson(Map<String, dynamic> json) =>
      _$VehicleClassFromJson(json);

  static double _decimalFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 1.0;
  }

  /// Check if this vehicle can accommodate given passengers and luggage.
  /// Optionally checks if tier level meets the minimum requirement.
  bool canAccommodate({
    required int passengers,
    int largeLuggage = 0,
    int smallLuggage = 0,
    int? minTier,
  }) {
    final capacityOk = passengers <= maxPassengers &&
        largeLuggage <= maxLargeLuggage &&
        smallLuggage <= maxSmallLuggage;
    final tierOk = minTier == null || tierLevel >= minTier;
    return capacityOk && tierOk;
  }
}

/// Response for available vehicles endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class AvailableVehiclesResponse {
  final int minTier;
  final int passengerTier;
  final int luggageTier;
  final List<VehicleClass> availableClasses;

  const AvailableVehiclesResponse({
    required this.minTier,
    required this.passengerTier,
    required this.luggageTier,
    required this.availableClasses,
  });

  factory AvailableVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableVehiclesResponseFromJson(json);
}
