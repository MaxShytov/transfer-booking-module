import 'package:json_annotation/json_annotation.dart';

part 'predefined_location.g.dart';

/// Predefined location from fixed routes.
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PredefinedLocation {
  final String address;
  final double lat;
  final double lng;
  final String type;
  final String typeDisplay;

  const PredefinedLocation({
    required this.address,
    required this.lat,
    required this.lng,
    required this.type,
    required this.typeDisplay,
  });

  factory PredefinedLocation.fromJson(Map<String, dynamic> json) =>
      _$PredefinedLocationFromJson(json);

  /// Check if this is an airport.
  bool get isAirport => type == 'airport';

  /// Get icon for this location type.
  String get iconName {
    switch (type) {
      case 'airport':
        return 'flight';
      case 'city_center':
        return 'location_city';
      case 'hotel_zone':
        return 'hotel';
      case 'resort':
        return 'beach_access';
      default:
        return 'place';
    }
  }
}
