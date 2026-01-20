import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_exceptions.dart';
import '../../data/models/extra_fee.dart';
import '../../data/models/predefined_location.dart';
import '../../data/models/price_calculation.dart';
import '../../data/models/vehicle_class.dart';
import '../../data/repositories/pricing_repository.dart';

/// Booking wizard step.
enum BookingStep {
  routeSelection,
  vehicleSelection,
  extrasSelection,
  passengerDetails,
  review,
}

/// Selected location in booking.
class SelectedLocation {
  final String address;
  final double lat;
  final double lng;
  final bool isPredefined;

  const SelectedLocation({
    required this.address,
    required this.lat,
    required this.lng,
    this.isPredefined = false,
  });

  factory SelectedLocation.fromPredefined(PredefinedLocation location) {
    return SelectedLocation(
      address: location.address,
      lat: location.lat,
      lng: location.lng,
      isPredefined: true,
    );
  }
}

/// Selected extra fee with quantity.
class SelectedExtraFee {
  final ExtraFee fee;
  final int quantity;

  const SelectedExtraFee({
    required this.fee,
    this.quantity = 1,
  });

  SelectedExtraFee copyWith({int? quantity}) {
    return SelectedExtraFee(
      fee: fee,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalAmount => fee.calculateFee(quantity: quantity);
}

/// Passenger details.
class PassengerDetails {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String? flightNumber;
  final String? specialRequests;

  const PassengerDetails({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    this.flightNumber,
    this.specialRequests,
  });

  PassengerDetails copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? flightNumber,
    String? specialRequests,
  }) {
    return PassengerDetails(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      flightNumber: flightNumber ?? this.flightNumber,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }
}

/// Get the next full hour time string (e.g., "17:00").
String _getNextHourTime() {
  final now = DateTime.now();
  final nextHour = now.hour + 1;
  if (nextHour >= 24) {
    return '00:00';
  }
  return '${nextHour.toString().padLeft(2, '0')}:00';
}

/// Get today's date (normalized to midnight).
DateTime _getTodayDate() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Main booking flow state.
class BookingFlowState {
  // Current step
  final BookingStep currentStep;

  // Step 1: Route selection
  final SelectedLocation? pickupLocation;
  final SelectedLocation? dropoffLocation;
  final DateTime? serviceDate;
  final String? pickupTime;
  final bool isRoundTrip;
  final DateTime? returnDate;
  final String? returnTime;
  final int numPassengers;
  final int numChildren;
  final int numLargeLuggage;
  final int numSmallLuggage;

  // Step 2: Vehicle selection
  final VehicleClass? selectedVehicle;

  // Step 3: Extras
  final List<SelectedExtraFee> selectedExtras;

  // Step 4: Passenger details
  final PassengerDetails? passengerDetails;

  // Price calculation
  final bool isCalculating;
  final PriceCalculation? priceCalculation;
  final String? error;

  const BookingFlowState({
    this.currentStep = BookingStep.routeSelection,
    this.pickupLocation,
    this.dropoffLocation,
    this.serviceDate,
    this.pickupTime,
    this.isRoundTrip = false,
    this.returnDate,
    this.returnTime,
    this.numPassengers = 1,
    this.numChildren = 0,
    this.numLargeLuggage = 0,
    this.numSmallLuggage = 0,
    this.selectedVehicle,
    this.selectedExtras = const [],
    this.passengerDetails,
    this.isCalculating = false,
    this.priceCalculation,
    this.error,
  });

  /// Create initial state with today's date and next hour time.
  factory BookingFlowState.initial() {
    return BookingFlowState(
      serviceDate: _getTodayDate(),
      pickupTime: _getNextHourTime(),
    );
  }

  BookingFlowState copyWith({
    BookingStep? currentStep,
    SelectedLocation? pickupLocation,
    SelectedLocation? dropoffLocation,
    DateTime? serviceDate,
    String? pickupTime,
    bool? isRoundTrip,
    DateTime? returnDate,
    String? returnTime,
    int? numPassengers,
    int? numChildren,
    int? numLargeLuggage,
    int? numSmallLuggage,
    VehicleClass? selectedVehicle,
    List<SelectedExtraFee>? selectedExtras,
    PassengerDetails? passengerDetails,
    bool? isCalculating,
    PriceCalculation? priceCalculation,
    String? error,
    bool clearPickup = false,
    bool clearDropoff = false,
    bool clearVehicle = false,
    bool clearExtras = false,
    bool clearPassenger = false,
    bool clearPrice = false,
    bool clearReturnDate = false,
    bool clearReturnTime = false,
  }) {
    return BookingFlowState(
      currentStep: currentStep ?? this.currentStep,
      pickupLocation: clearPickup ? null : (pickupLocation ?? this.pickupLocation),
      dropoffLocation: clearDropoff ? null : (dropoffLocation ?? this.dropoffLocation),
      serviceDate: serviceDate ?? this.serviceDate,
      pickupTime: pickupTime ?? this.pickupTime,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      returnDate: clearReturnDate ? null : (returnDate ?? this.returnDate),
      returnTime: clearReturnTime ? null : (returnTime ?? this.returnTime),
      numPassengers: numPassengers ?? this.numPassengers,
      numChildren: numChildren ?? this.numChildren,
      numLargeLuggage: numLargeLuggage ?? this.numLargeLuggage,
      numSmallLuggage: numSmallLuggage ?? this.numSmallLuggage,
      selectedVehicle: clearVehicle ? null : (selectedVehicle ?? this.selectedVehicle),
      selectedExtras: clearExtras ? const [] : (selectedExtras ?? this.selectedExtras),
      passengerDetails: clearPassenger ? null : (passengerDetails ?? this.passengerDetails),
      isCalculating: isCalculating ?? this.isCalculating,
      priceCalculation: clearPrice ? null : (priceCalculation ?? this.priceCalculation),
      error: error,
    );
  }

  /// Check if step 1 (route) is complete.
  bool get isRouteComplete =>
      pickupLocation != null &&
      dropoffLocation != null &&
      serviceDate != null &&
      pickupTime != null &&
      (!isRoundTrip || (returnDate != null && returnTime != null));

  /// Check if step 2 (vehicle) is complete.
  bool get isVehicleComplete => selectedVehicle != null;

  /// Check if step 4 (passenger) is complete.
  bool get isPassengerComplete => passengerDetails != null;

  /// Get current step number (1-5).
  int get stepNumber => currentStep.index + 1;

  /// Get total extra fees amount.
  double get extraFeesTotal {
    return selectedExtras.fold(0.0, (sum, extra) => sum + extra.totalAmount);
  }
}

/// Provider for booking flow.
final bookingFlowProvider =
    StateNotifierProvider<BookingFlowNotifier, BookingFlowState>((ref) {
  return BookingFlowNotifier(ref.watch(pricingRepositoryProvider));
});

class BookingFlowNotifier extends StateNotifier<BookingFlowState> {
  final PricingRepository _pricingRepository;

  BookingFlowNotifier(this._pricingRepository) : super(BookingFlowState.initial());

  // Step navigation
  void goToStep(BookingStep step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    final nextIndex = state.currentStep.index + 1;
    if (nextIndex < BookingStep.values.length) {
      state = state.copyWith(currentStep: BookingStep.values[nextIndex]);
    }
  }

  void previousStep() {
    final prevIndex = state.currentStep.index - 1;
    if (prevIndex >= 0) {
      state = state.copyWith(currentStep: BookingStep.values[prevIndex]);
    }
  }

  // Step 1: Route selection
  void setPickupLocation(SelectedLocation location) {
    state = state.copyWith(pickupLocation: location, clearPrice: true);
  }

  void setDropoffLocation(SelectedLocation location) {
    state = state.copyWith(dropoffLocation: location, clearPrice: true);
  }

  void setServiceDate(DateTime date) {
    state = state.copyWith(serviceDate: date, clearPrice: true);
  }

  void setPickupTime(String time) {
    state = state.copyWith(pickupTime: time, clearPrice: true);
  }

  void setRoundTrip(bool isRoundTrip) {
    state = state.copyWith(
      isRoundTrip: isRoundTrip,
      clearReturnDate: !isRoundTrip,
      clearReturnTime: !isRoundTrip,
      clearPrice: true,
    );
  }

  void setReturnDate(DateTime date) {
    state = state.copyWith(returnDate: date, clearPrice: true);
  }

  void setReturnTime(String time) {
    state = state.copyWith(returnTime: time, clearPrice: true);
  }

  void setNumPassengers(int num) {
    state = state.copyWith(
      numPassengers: num,
      clearVehicle: true,
      clearPrice: true,
    );
  }

  void setNumChildren(int num) {
    state = state.copyWith(
      numChildren: num,
      clearPrice: true,
    );
  }

  void setNumLargeLuggage(int num) {
    state = state.copyWith(
      numLargeLuggage: num,
      clearVehicle: true,
      clearPrice: true,
    );
  }

  void setNumSmallLuggage(int num) {
    state = state.copyWith(numSmallLuggage: num);
  }

  // Step 2: Vehicle selection
  void selectVehicle(VehicleClass vehicle) {
    state = state.copyWith(selectedVehicle: vehicle, clearPrice: true);
  }

  // Step 3: Extras
  void toggleExtra(ExtraFee fee) {
    final existing = state.selectedExtras.firstWhere(
      (e) => e.fee.feeCode == fee.feeCode,
      orElse: () => SelectedExtraFee(fee: fee, quantity: 0),
    );

    List<SelectedExtraFee> newExtras;
    if (existing.quantity > 0) {
      // Remove
      newExtras = state.selectedExtras
          .where((e) => e.fee.feeCode != fee.feeCode)
          .toList();
    } else {
      // Add
      newExtras = [...state.selectedExtras, SelectedExtraFee(fee: fee)];
    }

    state = state.copyWith(selectedExtras: newExtras, clearPrice: true);
  }

  void setExtraQuantity(ExtraFee fee, int quantity) {
    if (quantity <= 0) {
      // Remove
      final newExtras = state.selectedExtras
          .where((e) => e.fee.feeCode != fee.feeCode)
          .toList();
      state = state.copyWith(selectedExtras: newExtras, clearPrice: true);
    } else {
      // Update or add
      final existingIndex = state.selectedExtras
          .indexWhere((e) => e.fee.feeCode == fee.feeCode);

      List<SelectedExtraFee> newExtras;
      if (existingIndex >= 0) {
        newExtras = [...state.selectedExtras];
        newExtras[existingIndex] = newExtras[existingIndex].copyWith(quantity: quantity);
      } else {
        newExtras = [
          ...state.selectedExtras,
          SelectedExtraFee(fee: fee, quantity: quantity),
        ];
      }

      state = state.copyWith(selectedExtras: newExtras, clearPrice: true);
    }
  }

  bool isExtraSelected(String feeCode) {
    return state.selectedExtras.any((e) => e.fee.feeCode == feeCode);
  }

  int getExtraQuantity(String feeCode) {
    final extra = state.selectedExtras.firstWhere(
      (e) => e.fee.feeCode == feeCode,
      orElse: () => SelectedExtraFee(
        fee: ExtraFee(
          id: 0,
          feeName: '',
          feeCode: '',
          feeType: FeeType.flat,
          amount: 0,
          isOptional: true,
          displayOrder: 0,
          description: '',
        ),
        quantity: 0,
      ),
    );
    return extra.quantity;
  }

  // Step 4: Passenger details
  void setPassengerDetails(PassengerDetails details) {
    state = state.copyWith(passengerDetails: details);
  }

  // Price calculation
  Future<void> calculatePrice() async {
    if (!state.isRouteComplete) return;

    state = state.copyWith(isCalculating: true, error: null);

    try {
      final extraFees = state.selectedExtras
          .map((e) => ExtraFeeItem(feeCode: e.fee.feeCode, quantity: e.quantity))
          .toList();

      final result = await _pricingRepository.calculatePrice(
        pickupLat: state.pickupLocation!.lat,
        pickupLng: state.pickupLocation!.lng,
        dropoffLat: state.dropoffLocation!.lat,
        dropoffLng: state.dropoffLocation!.lng,
        serviceDate: state.serviceDate!,
        pickupTime: state.pickupTime!,
        numPassengers: state.numPassengers,
        numChildren: state.numChildren,
        numLargeLuggage: state.numLargeLuggage,
        numSmallLuggage: state.numSmallLuggage,
        vehicleClassId: state.selectedVehicle?.id,
        isRoundTrip: state.isRoundTrip,
        returnDate: state.returnDate,
        returnTime: state.returnTime,
        extraFees: extraFees,
      );

      state = state.copyWith(isCalculating: false, priceCalculation: result);
    } on DioException catch (e) {
      final apiError = e.error;
      if (apiError is ApiException) {
        state = state.copyWith(isCalculating: false, error: apiError.userMessage);
      } else {
        state = state.copyWith(isCalculating: false, error: e.message);
      }
    } catch (e) {
      state = state.copyWith(isCalculating: false, error: e.toString());
    }
  }

  // Reset
  void reset() {
    state = BookingFlowState.initial();
  }
}
