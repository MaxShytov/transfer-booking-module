import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/predefined_location.dart';
import '../../data/repositories/routes_repository.dart';

/// State for predefined locations.
class LocationsState {
  final bool isLoading;
  final List<PredefinedLocation> locations;
  final String? error;

  const LocationsState({
    this.isLoading = false,
    this.locations = const [],
    this.error,
  });

  LocationsState copyWith({
    bool? isLoading,
    List<PredefinedLocation>? locations,
    String? error,
  }) {
    return LocationsState(
      isLoading: isLoading ?? this.isLoading,
      locations: locations ?? this.locations,
      error: error,
    );
  }
}

/// Provider for predefined locations (for autocomplete).
final locationsProvider =
    StateNotifierProvider<LocationsNotifier, LocationsState>((ref) {
  return LocationsNotifier(ref.watch(routesRepositoryProvider));
});

class LocationsNotifier extends StateNotifier<LocationsState> {
  final RoutesRepository _repository;

  LocationsNotifier(this._repository) : super(const LocationsState());

  /// Load predefined locations.
  Future<void> loadLocations() async {
    if (state.locations.isNotEmpty) return; // Already loaded

    state = state.copyWith(isLoading: true, error: null);

    try {
      final locations = await _repository.getPredefinedLocations();
      state = state.copyWith(isLoading: false, locations: locations);
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

  /// Filter locations by search query.
  List<PredefinedLocation> filterLocations(String query) {
    if (query.isEmpty) return state.locations;

    final lowerQuery = query.toLowerCase();
    return state.locations.where((loc) {
      return loc.address.toLowerCase().contains(lowerQuery) ||
          loc.typeDisplay.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
