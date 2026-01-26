import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dispatcher_models.dart';
import '../../data/repositories/dispatcher_repository.dart';

/// Provider for booking filters state.
final bookingFiltersProvider =
    StateNotifierProvider<BookingFiltersNotifier, BookingFilters>((ref) {
  return BookingFiltersNotifier();
});

class BookingFiltersNotifier extends StateNotifier<BookingFilters> {
  BookingFiltersNotifier() : super(BookingFilters(date: DateTime.now()));

  void setDate(DateTime? date) {
    state = state.copyWith(date: date, clearDate: date == null);
  }

  void setDateRange(DateTime? from, DateTime? to) {
    state = BookingFilters(
      dateFrom: from,
      dateTo: to,
      status: state.status,
      paymentStatus: state.paymentStatus,
      search: state.search,
    );
  }

  void setStatus(String? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setPaymentStatus(String? paymentStatus) {
    state = state.copyWith(
      paymentStatus: paymentStatus,
      clearPaymentStatus: paymentStatus == null,
    );
  }

  void setSearch(String? search) {
    state = state.copyWith(search: search);
  }

  void setUnassigned(bool? unassigned) {
    state = state.copyWith(unassigned: unassigned);
  }

  void setDriver(int? driverId) {
    state = state.copyWith(
      assignedDriver: driverId,
      clearDriver: driverId == null,
    );
  }

  void clearAll() {
    state = const BookingFilters();
  }

  void showToday() {
    state = BookingFilters(date: DateTime.now());
  }

  void showTomorrow() {
    state = BookingFilters(date: DateTime.now().add(const Duration(days: 1)));
  }

  void showAll() {
    state = const BookingFilters();
  }
}

/// Provider for bookings list based on current filters.
final dispatcherBookingsProvider =
    FutureProvider.autoDispose<List<DispatcherBooking>>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  final filters = ref.watch(bookingFiltersProvider);
  return repository.getBookings(filters: filters);
});

/// Provider for today's bookings.
final todayBookingsProvider =
    FutureProvider.autoDispose<List<DispatcherBooking>>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return repository.getTodayBookings();
});

/// Provider for selected booking ID.
final selectedBookingIdProvider = StateProvider<int?>((ref) => null);

/// Provider for selected booking detail.
final selectedBookingProvider =
    FutureProvider.autoDispose<DispatcherBookingDetail?>((ref) async {
  final id = ref.watch(selectedBookingIdProvider);
  if (id == null) return null;
  final repository = ref.watch(dispatcherRepositoryProvider);
  return repository.getBookingDetail(id);
});

/// Provider for booking detail by ID (parameterized).
final bookingDetailProvider = FutureProvider.autoDispose
    .family<DispatcherBookingDetail, int>((ref, id) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return repository.getBookingDetail(id);
});

/// Provider for dispatcher dashboard statistics.
final dispatcherStatsProvider =
    FutureProvider.autoDispose<DispatcherStats>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return repository.getStats();
});

/// Provider for all drivers list.
final driversProvider =
    FutureProvider.autoDispose<List<DriverInfo>>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return repository.getDrivers();
});

/// Provider for available drivers list.
final availableDriversProvider =
    FutureProvider.autoDispose<List<DriverInfo>>((ref) async {
  final repository = ref.watch(dispatcherRepositoryProvider);
  return repository.getAvailableDrivers();
});

/// Notifier for dispatcher actions (mutations).
class DispatcherActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final DispatcherRepository _repository;
  final Ref _ref;

  DispatcherActionsNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<DispatcherBookingDetail?> updateStatus(
    int bookingId,
    String status, {
    String? cancellationReason,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.updateBookingStatus(
        bookingId,
        status,
        cancellationReason: cancellationReason,
      );
      state = const AsyncValue.data(null);
      _refreshBookings();
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<DispatcherBookingDetail?> assignDriver(
    int bookingId,
    int? driverId,
  ) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.assignDriver(bookingId, driverId);
      state = const AsyncValue.data(null);
      _refreshBookings();
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<DispatcherBookingDetail?> updatePaymentStatus(
    int bookingId,
    String paymentStatus,
  ) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.updatePaymentStatus(
        bookingId,
        paymentStatus,
      );
      state = const AsyncValue.data(null);
      _refreshBookings();
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<DispatcherBookingDetail?> updateNotes(
    int bookingId, {
    String? dispatcherNotes,
    String? internalNotes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.updateNotes(
        bookingId,
        dispatcherNotes: dispatcherNotes,
        internalNotes: internalNotes,
      );
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<DriverInfo?> toggleDriverAvailability(int driverId) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.toggleDriverAvailability(driverId);
      state = const AsyncValue.data(null);
      _ref.invalidate(driversProvider);
      _ref.invalidate(availableDriversProvider);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  void _refreshBookings() {
    _ref.invalidate(dispatcherBookingsProvider);
    _ref.invalidate(todayBookingsProvider);
    _ref.invalidate(dispatcherStatsProvider);
    final selectedId = _ref.read(selectedBookingIdProvider);
    if (selectedId != null) {
      _ref.invalidate(bookingDetailProvider(selectedId));
    }
  }
}

/// Provider for dispatcher actions.
final dispatcherActionsProvider =
    StateNotifierProvider<DispatcherActionsNotifier, AsyncValue<void>>((ref) {
  return DispatcherActionsNotifier(
    ref.watch(dispatcherRepositoryProvider),
    ref,
  );
});
