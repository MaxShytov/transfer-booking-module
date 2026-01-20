import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/vehicle_class.dart';
import '../../data/repositories/vehicles_repository.dart';

/// State for vehicle classes list.
class VehiclesState {
  final bool isLoading;
  final List<VehicleClass> vehicles;
  final String? error;

  const VehiclesState({
    this.isLoading = false,
    this.vehicles = const [],
    this.error,
  });

  VehiclesState copyWith({
    bool? isLoading,
    List<VehicleClass>? vehicles,
    String? error,
  }) {
    return VehiclesState(
      isLoading: isLoading ?? this.isLoading,
      vehicles: vehicles ?? this.vehicles,
      error: error,
    );
  }
}

/// Provider for all vehicle classes.
final vehiclesProvider =
    StateNotifierProvider<VehiclesNotifier, VehiclesState>((ref) {
  return VehiclesNotifier(ref.watch(vehiclesRepositoryProvider));
});

class VehiclesNotifier extends StateNotifier<VehiclesState> {
  final VehiclesRepository _repository;

  VehiclesNotifier(this._repository) : super(const VehiclesState());

  /// Load all vehicle classes.
  Future<void> loadVehicles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final vehicles = await _repository.getVehicleClasses();
      state = state.copyWith(isLoading: false, vehicles: vehicles);
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        state = state.copyWith(isLoading: false, error: apiError.userMessage);
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// State for available vehicles (filtered by passengers/luggage).
class AvailableVehiclesState {
  final bool isLoading;
  final int minTier;
  final List<VehicleClass> availableClasses;
  final String? error;

  const AvailableVehiclesState({
    this.isLoading = false,
    this.minTier = 1,
    this.availableClasses = const [],
    this.error,
  });

  AvailableVehiclesState copyWith({
    bool? isLoading,
    int? minTier,
    List<VehicleClass>? availableClasses,
    String? error,
  }) {
    return AvailableVehiclesState(
      isLoading: isLoading ?? this.isLoading,
      minTier: minTier ?? this.minTier,
      availableClasses: availableClasses ?? this.availableClasses,
      error: error,
    );
  }
}

/// Provider for available vehicles based on requirements.
final availableVehiclesProvider =
    StateNotifierProvider<AvailableVehiclesNotifier, AvailableVehiclesState>(
        (ref) {
  return AvailableVehiclesNotifier(ref.watch(vehiclesRepositoryProvider));
});

class AvailableVehiclesNotifier extends StateNotifier<AvailableVehiclesState> {
  final VehiclesRepository _repository;

  AvailableVehiclesNotifier(this._repository)
      : super(const AvailableVehiclesState());

  /// Load available vehicles for given passengers and luggage.
  Future<void> loadAvailableVehicles({
    required int numPassengers,
    int numLargeLuggage = 0,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getAvailableVehicles(
        numPassengers: numPassengers,
        numLargeLuggage: numLargeLuggage,
      );
      state = state.copyWith(
        isLoading: false,
        minTier: response.minTier,
        availableClasses: response.availableClasses,
      );
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        state = state.copyWith(isLoading: false, error: apiError.userMessage);
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Reset to initial state.
  void reset() {
    state = const AvailableVehiclesState();
  }
}
