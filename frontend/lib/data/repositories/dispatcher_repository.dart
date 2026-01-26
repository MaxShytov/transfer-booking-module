import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/dispatcher_models.dart';

/// Provider for the DispatcherRepository.
final dispatcherRepositoryProvider = Provider<DispatcherRepository>((ref) {
  return DispatcherRepository(ref.watch(dioProvider));
});

/// Repository for dispatcher API operations.
class DispatcherRepository {
  final Dio _dio;

  DispatcherRepository(this._dio);

  /// Get list of bookings with optional filters.
  Future<List<DispatcherBooking>> getBookings({
    BookingFilters? filters,
  }) async {
    final queryParams = filters?.toQueryParams() ?? {};
    final response = await _dio.get(
      '/dispatcher/bookings/',
      queryParameters: queryParams,
    );

    if (response.data is Map && response.data['results'] != null) {
      // Paginated response
      return (response.data['results'] as List)
          .map((e) => DispatcherBooking.fromJson(e))
          .toList();
    }
    // Non-paginated response
    return (response.data as List)
        .map((e) => DispatcherBooking.fromJson(e))
        .toList();
  }

  /// Get today's bookings.
  Future<List<DispatcherBooking>> getTodayBookings() async {
    final response = await _dio.get('/dispatcher/bookings/today/');
    return (response.data as List)
        .map((e) => DispatcherBooking.fromJson(e))
        .toList();
  }

  /// Get upcoming bookings (next 7 days).
  Future<List<DispatcherBooking>> getUpcomingBookings() async {
    final response = await _dio.get('/dispatcher/bookings/upcoming/');
    return (response.data as List)
        .map((e) => DispatcherBooking.fromJson(e))
        .toList();
  }

  /// Get booking detail by ID.
  Future<DispatcherBookingDetail> getBookingDetail(int id) async {
    final response = await _dio.get('/dispatcher/bookings/$id/');
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Update booking status.
  Future<DispatcherBookingDetail> updateBookingStatus(
    int id,
    String status, {
    String? cancellationReason,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (cancellationReason != null) {
      data['cancellation_reason'] = cancellationReason;
    }
    final response = await _dio.post(
      '/dispatcher/bookings/$id/update_status/',
      data: data,
    );
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Assign driver to booking.
  Future<DispatcherBookingDetail> assignDriver(int bookingId, int? driverId) async {
    final response = await _dio.post(
      '/dispatcher/bookings/$bookingId/assign_driver/',
      data: {'driver_id': driverId},
    );
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Update payment status.
  Future<DispatcherBookingDetail> updatePaymentStatus(
    int id,
    String paymentStatus,
  ) async {
    final response = await _dio.post(
      '/dispatcher/bookings/$id/update_payment_status/',
      data: {'payment_status': paymentStatus},
    );
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Update dispatcher/internal notes.
  Future<DispatcherBookingDetail> updateNotes(
    int id, {
    String? dispatcherNotes,
    String? internalNotes,
  }) async {
    final data = <String, dynamic>{};
    if (dispatcherNotes != null) {
      data['dispatcher_notes'] = dispatcherNotes;
    }
    if (internalNotes != null) {
      data['internal_notes'] = internalNotes;
    }
    final response = await _dio.post(
      '/dispatcher/bookings/$id/update_notes/',
      data: data,
    );
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Update booking (full update).
  Future<DispatcherBookingDetail> updateBooking(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.patch(
      '/dispatcher/bookings/$id/',
      data: data,
    );
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Create new booking (manual).
  Future<DispatcherBookingDetail> createBooking(Map<String, dynamic> data) async {
    final response = await _dio.post(
      '/dispatcher/bookings/',
      data: data,
    );
    return DispatcherBookingDetail.fromJson(response.data);
  }

  /// Get dispatcher dashboard statistics.
  Future<DispatcherStats> getStats() async {
    final response = await _dio.get('/dispatcher/bookings/stats/');
    return DispatcherStats.fromJson(response.data);
  }

  /// Get list of drivers.
  Future<List<DriverInfo>> getDrivers() async {
    final response = await _dio.get('/dispatcher/drivers/');
    if (response.data is Map && response.data['results'] != null) {
      return (response.data['results'] as List)
          .map((e) => DriverInfo.fromJson(e))
          .toList();
    }
    return (response.data as List)
        .map((e) => DriverInfo.fromJson(e))
        .toList();
  }

  /// Get available drivers.
  Future<List<DriverInfo>> getAvailableDrivers() async {
    final response = await _dio.get('/dispatcher/drivers/available/');
    return (response.data as List)
        .map((e) => DriverInfo.fromJson(e))
        .toList();
  }

  /// Toggle driver availability.
  Future<DriverInfo> toggleDriverAvailability(int driverId) async {
    final response = await _dio.post(
      '/dispatcher/drivers/$driverId/toggle_availability/',
    );
    return DriverInfo.fromJson(response.data);
  }

  /// Get bookings assigned to a driver.
  Future<List<DispatcherBooking>> getDriverBookings(
    int driverId, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final queryParams = <String, String>{};
    if (dateFrom != null) {
      queryParams['date_from'] =
          '${dateFrom.year}-${dateFrom.month.toString().padLeft(2, '0')}-${dateFrom.day.toString().padLeft(2, '0')}';
    }
    if (dateTo != null) {
      queryParams['date_to'] =
          '${dateTo.year}-${dateTo.month.toString().padLeft(2, '0')}-${dateTo.day.toString().padLeft(2, '0')}';
    }
    final response = await _dio.get(
      '/dispatcher/drivers/$driverId/bookings/',
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((e) => DispatcherBooking.fromJson(e))
        .toList();
  }
}
