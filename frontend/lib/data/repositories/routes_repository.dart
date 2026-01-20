import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/fixed_route.dart';
import '../models/predefined_location.dart';

/// Provider for RoutesRepository.
final routesRepositoryProvider = Provider<RoutesRepository>((ref) {
  return RoutesRepository(dio: ref.watch(dioProvider));
});

/// Repository for route operations.
class RoutesRepository {
  final Dio _dio;

  RoutesRepository({required Dio dio}) : _dio = dio;

  /// Get all active fixed routes.
  Future<List<FixedRoute>> getFixedRoutes() async {
    final response = await _dio.get('/routes/fixed/');
    final data = response.data['data'] as List;
    return data.map((json) => FixedRoute.fromJson(json)).toList();
  }

  /// Get predefined locations for autocomplete.
  Future<List<PredefinedLocation>> getPredefinedLocations() async {
    final response = await _dio.get('/routes/fixed/locations/');
    final data = response.data['data'] as List;
    return data.map((json) => PredefinedLocation.fromJson(json)).toList();
  }

  /// Match coordinates to a fixed route.
  Future<RouteMatchResponse> matchRoute({
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
  }) async {
    final response = await _dio.post(
      '/routes/fixed/match/',
      data: {
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'dropoff_lat': dropoffLat,
        'dropoff_lng': dropoffLng,
      },
    );
    return RouteMatchResponse.fromJson(response.data['data']);
  }

  /// Get distance pricing rules.
  Future<List<DistancePricingRule>> getDistancePricingRules() async {
    final response = await _dio.get('/routes/distance-rules/');
    final data = response.data['data'] as List;
    return data.map((json) => DistancePricingRule.fromJson(json)).toList();
  }
}
