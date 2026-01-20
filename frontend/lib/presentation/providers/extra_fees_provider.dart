import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/extra_fee.dart';
import '../../data/repositories/pricing_repository.dart';

/// State for extra fees list.
class ExtraFeesState {
  final bool isLoading;
  final List<ExtraFee> fees;
  final String? error;

  const ExtraFeesState({
    this.isLoading = false,
    this.fees = const [],
    this.error,
  });

  ExtraFeesState copyWith({
    bool? isLoading,
    List<ExtraFee>? fees,
    String? error,
  }) {
    return ExtraFeesState(
      isLoading: isLoading ?? this.isLoading,
      fees: fees ?? this.fees,
      error: error,
    );
  }

  /// Get only optional fees.
  List<ExtraFee> get optionalFees => fees.where((f) => f.isOptional).toList();

  /// Get only mandatory fees.
  List<ExtraFee> get mandatoryFees => fees.where((f) => !f.isOptional).toList();
}

/// Provider for extra fees.
final extraFeesProvider =
    StateNotifierProvider<ExtraFeesNotifier, ExtraFeesState>((ref) {
  return ExtraFeesNotifier(ref.watch(pricingRepositoryProvider));
});

class ExtraFeesNotifier extends StateNotifier<ExtraFeesState> {
  final PricingRepository _repository;

  ExtraFeesNotifier(this._repository) : super(const ExtraFeesState());

  /// Load extra fees.
  Future<void> loadExtraFees() async {
    if (state.fees.isNotEmpty) return; // Already loaded

    state = state.copyWith(isLoading: true, error: null);

    try {
      final fees = await _repository.getExtraFees();
      state = state.copyWith(isLoading: false, fees: fees);
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
