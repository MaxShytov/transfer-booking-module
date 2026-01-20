import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/vehicle_class.dart';

/// Provider for VehiclesRepository.
final vehiclesRepositoryProvider = Provider<VehiclesRepository>((ref) {
  return VehiclesRepository(dio: ref.watch(dioProvider));
});

/// Repository for vehicle operations.
class VehiclesRepository {
  final Dio _dio;

  VehiclesRepository({required Dio dio}) : _dio = dio;

  /// Get all active vehicle classes.
  Future<List<VehicleClass>> getVehicleClasses() async {
    final response = await _dio.get('/vehicles/classes/');
    final data = response.data['data'] as List;
    return data.map((json) => VehicleClass.fromJson(json)).toList();
  }

  /// Get vehicle class by ID.
  Future<VehicleClass> getVehicleClass(int id) async {
    final response = await _dio.get('/vehicles/classes/$id/');
    return VehicleClass.fromJson(response.data['data']);
  }

  /// Get available vehicle classes for given passengers and luggage.
  Future<AvailableVehiclesResponse> getAvailableVehicles({
    required int numPassengers,
    int numLargeLuggage = 0,
  }) async {
    final response = await _dio.post(
      '/vehicles/classes/available/',
      data: {
        'num_passengers': numPassengers,
        'num_large_luggage': numLargeLuggage,
      },
    );
    return AvailableVehiclesResponse.fromJson(response.data['data']);
  }
}
