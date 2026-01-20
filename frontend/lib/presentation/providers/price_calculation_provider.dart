import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/price_calculation.dart';
import 'booking_flow_provider.dart';

/// Provider that exposes price calculation from booking flow state.
/// This is a derived provider for convenient access to price data.
final priceCalculationProvider = Provider<PriceCalculation?>((ref) {
  final bookingState = ref.watch(bookingFlowProvider);
  return bookingState.priceCalculation;
});

/// Provider for checking if price is being calculated.
final isCalculatingPriceProvider = Provider<bool>((ref) {
  final bookingState = ref.watch(bookingFlowProvider);
  return bookingState.isCalculating;
});

/// Provider for price calculation error.
final priceCalculationErrorProvider = Provider<String?>((ref) {
  final bookingState = ref.watch(bookingFlowProvider);
  return bookingState.error;
});

/// Provider for final price (0 if not calculated).
final finalPriceProvider = Provider<double>((ref) {
  final calculation = ref.watch(priceCalculationProvider);
  return calculation?.finalPrice ?? 0.0;
});

/// Provider for formatted final price.
final formattedFinalPriceProvider = Provider<String>((ref) {
  final price = ref.watch(finalPriceProvider);
  return '€${price.toStringAsFixed(2)}';
});
