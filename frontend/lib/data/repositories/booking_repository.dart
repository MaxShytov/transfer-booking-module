import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/booking.dart';
import '../models/price_calculation.dart';

/// Provider for BookingRepository.
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(dio: ref.watch(dioProvider));
});

/// Repository for booking operations.
class BookingRepository {
  final Dio _dio;

  BookingRepository({required Dio dio}) : _dio = dio;

  /// Create a new booking.
  Future<BookingResponse> createBooking({
    // Route
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String dropoffAddress,
    required double dropoffLat,
    required double dropoffLng,
    required DateTime serviceDate,
    required String pickupTime,
    // Round trip
    bool isRoundTrip = false,
    DateTime? returnDate,
    String? returnTime,
    // Passengers & luggage
    required int numPassengers,
    int numChildren = 0,
    int numLargeLuggage = 0,
    int numSmallLuggage = 0,
    // Vehicle
    required int vehicleClassId,
    // Pricing
    required PriceCalculation priceCalculation,
    // Customer
    required String customerFirstName,
    required String customerLastName,
    required String customerPhone,
    required String customerEmail,
    // Trip details
    String? flightNumber,
    String? returnFlightNumber,
    String? specialRequests,
  }) async {
    final response = await _dio.post(
      '/bookings/create/',
      data: {
        // Route
        'pickup_address': pickupAddress,
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'dropoff_address': dropoffAddress,
        'dropoff_lat': dropoffLat,
        'dropoff_lng': dropoffLng,
        'service_date': _formatDate(serviceDate),
        'pickup_time': pickupTime,
        // Round trip
        'is_round_trip': isRoundTrip,
        if (isRoundTrip && returnDate != null)
          'return_date': _formatDate(returnDate),
        if (isRoundTrip && returnTime != null) 'return_time': returnTime,
        // Passengers & luggage
        'num_passengers': numPassengers,
        'num_children': numChildren,
        'num_large_luggage': numLargeLuggage,
        'num_small_luggage': numSmallLuggage,
        // Vehicle
        'vehicle_class_id': vehicleClassId,
        // Pricing
        'pricing_type': priceCalculation.routeType,
        'route_name': priceCalculation.routeName,
        'distance_km': priceCalculation.distanceKm,
        'base_price': priceCalculation.basePrice,
        'vehicle_multiplier': priceCalculation.vehicleMultiplier,
        'passenger_multiplier': priceCalculation.passengerMultiplier,
        'seasonal_multiplier': priceCalculation.seasonalMultiplier,
        'time_multiplier': priceCalculation.timeMultiplier,
        'subtotal': priceCalculation.subtotal,
        'extra_fees': priceCalculation.extraFees
            .map((e) => {
                  'fee_code': e.feeCode,
                  'fee_name': e.feeName,
                  'fee_type': e.feeType,
                  'quantity': e.quantity,
                  'unit_amount': e.unitAmount,
                  'total_amount': e.totalAmount,
                })
            .toList(),
        'extra_fees_total': priceCalculation.extraFeesTotal,
        'final_price': priceCalculation.finalPrice,
        // Customer
        'customer_first_name': customerFirstName,
        'customer_last_name': customerLastName,
        'customer_phone': customerPhone,
        'customer_email': customerEmail,
        // Trip details
        'flight_number': flightNumber ?? '',
        'return_flight_number': returnFlightNumber ?? '',
        'special_requests': specialRequests ?? '',
      },
    );
    return BookingResponse.fromJson(response.data);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get list of user's bookings.
  Future<List<BookingListItem>> getBookings() async {
    final response = await _dio.get('/bookings/');
    final data = response.data['data'] as List;
    return data.map((json) => BookingListItem.fromJson(json)).toList();
  }

  /// Get booking details by ID.
  Future<BookingDetail> getBookingDetail(int bookingId) async {
    final response = await _dio.get('/bookings/$bookingId/');
    return BookingDetail.fromJson(response.data['data']);
  }
}
