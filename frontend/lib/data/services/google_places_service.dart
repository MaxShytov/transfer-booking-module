import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/env_config.dart';

/// Model for place autocomplete prediction.
class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting = json['structured_formatting'] ?? {};
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: structuredFormatting['main_text'] ?? json['description'] ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
    );
  }
}

/// Model for place details with coordinates.
class PlaceDetails {
  final String placeId;
  final String address;
  final double lat;
  final double lng;

  PlaceDetails({
    required this.placeId,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] ?? {};
    final location = geometry['location'] ?? {};
    return PlaceDetails(
      placeId: json['place_id'] ?? '',
      address: json['formatted_address'] ?? json['name'] ?? '',
      lat: (location['lat'] ?? 0).toDouble(),
      lng: (location['lng'] ?? 0).toDouble(),
    );
  }
}

/// Service for Google Places API operations.
class GooglePlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String _apiKey = EnvConfig.googleMapsApiKey;

  /// Search for places using autocomplete.
  /// [input] - The search query
  /// [location] - Optional bias location (lat,lng)
  /// [radius] - Optional radius in meters for location bias
  /// [language] - Language code for results (default: en)
  Future<List<PlacePrediction>> autocomplete({
    required String input,
    String? location,
    int? radius,
    String language = 'en',
    String? sessionToken,
  }) async {
    if (input.isEmpty) return [];

    final params = {
      'input': input,
      'key': _apiKey,
      'language': language,
      // Bias results to Switzerland/Europe area
      'components': 'country:ch|country:fr|country:it|country:de|country:at',
    };

    if (location != null) {
      params['location'] = location;
    }
    if (radius != null) {
      params['radius'] = radius.toString();
    }
    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    final uri = Uri.parse('$_baseUrl/autocomplete/json').replace(
      queryParameters: params,
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get place details by place ID.
  Future<PlaceDetails?> getPlaceDetails({
    required String placeId,
    String? sessionToken,
  }) async {
    final params = {
      'place_id': placeId,
      'key': _apiKey,
      'fields': 'place_id,formatted_address,name,geometry',
    };

    if (sessionToken != null) {
      params['sessiontoken'] = sessionToken;
    }

    final uri = Uri.parse('$_baseUrl/details/json').replace(
      queryParameters: params,
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          return PlaceDetails.fromJson(data['result']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Geocode an address to get coordinates.
  Future<PlaceDetails?> geocodeAddress(String address) async {
    final params = {
      'address': address,
      'key': _apiKey,
    };

    final uri = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json')
        .replace(queryParameters: params);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final result = data['results'][0];
          final location = result['geometry']['location'];
          return PlaceDetails(
            placeId: result['place_id'] ?? '',
            address: result['formatted_address'] ?? address,
            lat: (location['lat'] ?? 0).toDouble(),
            lng: (location['lng'] ?? 0).toDouble(),
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
