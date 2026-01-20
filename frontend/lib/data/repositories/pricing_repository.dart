import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../models/extra_fee.dart';
import '../models/price_calculation.dart';

/// Provider for PricingRepository.
final pricingRepositoryProvider = Provider<PricingRepository>((ref) {
  return PricingRepository(dio: ref.watch(dioProvider));
});

/// Extra fee item for price calculation request.
class ExtraFeeItem {
  final String feeCode;
  final int quantity;

  const ExtraFeeItem({
    required this.feeCode,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'fee_code': feeCode,
        'quantity': quantity,
      };
}

/// Repository for pricing operations.
class PricingRepository {
  final Dio _dio;

  PricingRepository({required Dio dio}) : _dio = dio;

  /// Get all active extra fees.
  Future<List<ExtraFee>> getExtraFees() async {
    final response = await _dio.get('/pricing/extra-fees/');
    final data = response.data['data'] as List;
    return data.map((json) => ExtraFee.fromJson(json)).toList();
  }

  /// Calculate price for a transfer.
  Future<PriceCalculation> calculatePrice({
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required DateTime serviceDate,
    required String pickupTime,
    required int numPassengers,
    int numChildren = 0,
    int numLargeLuggage = 0,
    int numSmallLuggage = 0,
    int? vehicleClassId,
    bool isRoundTrip = false,
    DateTime? returnDate,
    String? returnTime,
    List<ExtraFeeItem> extraFees = const [],
  }) async {
    final response = await _dio.post(
      '/pricing/calculate/',
      data: {
        'pickup_lat': pickupLat,
        'pickup_lng': pickupLng,
        'dropoff_lat': dropoffLat,
        'dropoff_lng': dropoffLng,
        'service_date': _formatDate(serviceDate),
        'pickup_time': pickupTime,
        'num_passengers': numPassengers,
        'num_children': numChildren,
        'num_large_luggage': numLargeLuggage,
        'num_small_luggage': numSmallLuggage,
        if (vehicleClassId != null) 'vehicle_class_id': vehicleClassId,
        'is_round_trip': isRoundTrip,
        if (isRoundTrip && returnDate != null)
          'return_date': _formatDate(returnDate),
        if (isRoundTrip && returnTime != null) 'return_time': returnTime,
        'extra_fees': extraFees.map((e) => e.toJson()).toList(),
      },
    );
    return PriceCalculation.fromJson(response.data['data']);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
