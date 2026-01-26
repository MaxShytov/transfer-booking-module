/// Driver information model.
class DriverInfo {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final String? vehiclePlate;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehicleClassName;
  final bool isAvailable;
  final int activeBookingsCount;

  const DriverInfo({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    this.vehiclePlate,
    this.vehicleModel,
    this.vehicleColor,
    this.vehicleClassName,
    required this.isAvailable,
    this.activeBookingsCount = 0,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      vehiclePlate: json['vehicle_plate'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      vehicleColor: json['vehicle_color'] as String?,
      vehicleClassName: json['vehicle_class_name'] as String?,
      isAvailable: json['is_available'] as bool? ?? false,
      activeBookingsCount: json['active_bookings_count'] as int? ?? 0,
    );
  }

  String get displayName => fullName.isNotEmpty ? fullName : email;
  String get vehicleDisplay =>
      vehicleModel != null ? '$vehicleModel ($vehiclePlate)' : 'No vehicle';
}

/// Booking list item for dispatcher dashboard.
class DispatcherBooking {
  final int id;
  final String bookingReference;
  final String pickupAddress;
  final String dropoffAddress;
  final String serviceDate;
  final String pickupTime;
  final bool isRoundTrip;
  final String? returnDate;
  final String? returnTime;
  final int numPassengers;
  final int numLargeLuggage;
  final int numSmallLuggage;
  final String vehicleClassName;
  final double finalPrice;
  final String currency;
  final String status;
  final String paymentStatus;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final int? assignedDriverId;
  final String? assignedDriverName;
  final String? assignedDriverPhone;
  final String? dispatcherNotes;
  final String createdAt;

  const DispatcherBooking({
    required this.id,
    required this.bookingReference,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.serviceDate,
    required this.pickupTime,
    required this.isRoundTrip,
    this.returnDate,
    this.returnTime,
    required this.numPassengers,
    required this.numLargeLuggage,
    required this.numSmallLuggage,
    required this.vehicleClassName,
    required this.finalPrice,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    this.assignedDriverId,
    this.assignedDriverName,
    this.assignedDriverPhone,
    this.dispatcherNotes,
    required this.createdAt,
  });

  factory DispatcherBooking.fromJson(Map<String, dynamic> json) {
    return DispatcherBooking(
      id: json['id'] as int,
      bookingReference: json['booking_reference'] as String,
      pickupAddress: json['pickup_address'] as String,
      dropoffAddress: json['dropoff_address'] as String,
      serviceDate: json['service_date'] as String,
      pickupTime: json['pickup_time'] as String,
      isRoundTrip: json['is_round_trip'] as bool? ?? false,
      returnDate: json['return_date'] as String?,
      returnTime: json['return_time'] as String?,
      numPassengers: json['num_passengers'] as int? ?? 1,
      numLargeLuggage: json['num_large_luggage'] as int? ?? 0,
      numSmallLuggage: json['num_small_luggage'] as int? ?? 0,
      vehicleClassName: json['vehicle_class_name'] as String? ?? '',
      finalPrice: _parseDouble(json['final_price']),
      currency: json['currency'] as String? ?? 'EUR',
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String? ?? '',
      customerEmail: json['customer_email'] as String? ?? '',
      assignedDriverId: json['assigned_driver'] as int?,
      assignedDriverName: json['assigned_driver_name'] as String?,
      assignedDriverPhone: json['assigned_driver_phone'] as String?,
      dispatcherNotes: json['dispatcher_notes'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  bool get hasDriver => assignedDriverId != null;

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'В ожидании';
      case 'confirmed':
        return 'Подтверждено';
      case 'in_progress':
        return 'В пути';
      case 'completed':
        return 'Завершено';
      case 'cancelled':
        return 'Отменено';
      default:
        return status;
    }
  }

  String get paymentStatusDisplay {
    switch (paymentStatus) {
      case 'unpaid':
        return 'Не оплачено';
      case 'deposit_paid':
        return 'Депозит внесён';
      case 'fully_paid':
        return 'Оплачено';
      case 'refunded':
        return 'Возврат';
      default:
        return paymentStatus;
    }
  }
}

/// Booking detail for dispatcher dashboard (full data).
class DispatcherBookingDetail {
  final int id;
  final String bookingReference;
  // Route
  final String pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String? pickupNotes;
  final String dropoffAddress;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? dropoffNotes;
  final String serviceDate;
  final String pickupTime;
  // Round trip
  final bool isRoundTrip;
  final String? returnDate;
  final String? returnTime;
  final String? returnFlightNumber;
  // Passengers
  final int numPassengers;
  final int numLargeLuggage;
  final int numSmallLuggage;
  final bool hasChildren;
  final List<int> childrenAges;
  // Vehicle
  final String vehicleClassName;
  final String? vehicleClassImage;
  // Flight & requests
  final String? flightNumber;
  final String? specialRequests;
  // Pricing
  final String pricingType;
  final double? distanceKm;
  final int? durationMinutes;
  final double basePrice;
  final double vehicleClassMultiplier;
  final double passengerMultiplier;
  final double seasonalMultiplier;
  final double timeMultiplier;
  final double subtotal;
  final List<Map<String, dynamic>> extraFeesJson;
  final double extraFeesTotal;
  final double finalPrice;
  final String currency;
  // Customer
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  // Status
  final String status;
  final String paymentStatus;
  final String? paymentMethod;
  // Driver
  final int? assignedDriverId;
  final DriverInfo? assignedDriverInfo;
  // Internal
  final String? internalNotes;
  final String? dispatcherNotes;
  final String? cancellationReason;
  // Timestamps
  final String createdAt;
  final String? updatedAt;
  final String? confirmedAt;
  final String? completedAt;
  final String? cancelledAt;

  const DispatcherBookingDetail({
    required this.id,
    required this.bookingReference,
    required this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    this.pickupNotes,
    required this.dropoffAddress,
    this.dropoffLat,
    this.dropoffLng,
    this.dropoffNotes,
    required this.serviceDate,
    required this.pickupTime,
    required this.isRoundTrip,
    this.returnDate,
    this.returnTime,
    this.returnFlightNumber,
    required this.numPassengers,
    required this.numLargeLuggage,
    required this.numSmallLuggage,
    required this.hasChildren,
    required this.childrenAges,
    required this.vehicleClassName,
    this.vehicleClassImage,
    this.flightNumber,
    this.specialRequests,
    required this.pricingType,
    this.distanceKm,
    this.durationMinutes,
    required this.basePrice,
    required this.vehicleClassMultiplier,
    required this.passengerMultiplier,
    required this.seasonalMultiplier,
    required this.timeMultiplier,
    required this.subtotal,
    required this.extraFeesJson,
    required this.extraFeesTotal,
    required this.finalPrice,
    required this.currency,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.status,
    required this.paymentStatus,
    this.paymentMethod,
    this.assignedDriverId,
    this.assignedDriverInfo,
    this.internalNotes,
    this.dispatcherNotes,
    this.cancellationReason,
    required this.createdAt,
    this.updatedAt,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory DispatcherBookingDetail.fromJson(Map<String, dynamic> json) {
    return DispatcherBookingDetail(
      id: json['id'] as int,
      bookingReference: json['booking_reference'] as String,
      pickupAddress: json['pickup_address'] as String,
      pickupLat: _parseDoubleNullable(json['pickup_lat']),
      pickupLng: _parseDoubleNullable(json['pickup_lng']),
      pickupNotes: json['pickup_notes'] as String?,
      dropoffAddress: json['dropoff_address'] as String,
      dropoffLat: _parseDoubleNullable(json['dropoff_lat']),
      dropoffLng: _parseDoubleNullable(json['dropoff_lng']),
      dropoffNotes: json['dropoff_notes'] as String?,
      serviceDate: json['service_date'] as String,
      pickupTime: json['pickup_time'] as String,
      isRoundTrip: json['is_round_trip'] as bool? ?? false,
      returnDate: json['return_date'] as String?,
      returnTime: json['return_time'] as String?,
      returnFlightNumber: json['return_flight_number'] as String?,
      numPassengers: json['num_passengers'] as int? ?? 1,
      numLargeLuggage: json['num_large_luggage'] as int? ?? 0,
      numSmallLuggage: json['num_small_luggage'] as int? ?? 0,
      hasChildren: json['has_children'] as bool? ?? false,
      childrenAges: (json['children_ages'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      vehicleClassName: json['vehicle_class_name'] as String? ?? '',
      vehicleClassImage: json['vehicle_class_image'] as String?,
      flightNumber: json['flight_number'] as String?,
      specialRequests: json['special_requests'] as String?,
      pricingType: json['pricing_type'] as String? ?? '',
      distanceKm: _parseDoubleNullable(json['distance_km']),
      durationMinutes: json['duration_minutes'] as int?,
      basePrice: _parseDouble(json['base_price']),
      vehicleClassMultiplier: _parseDouble(json['vehicle_class_multiplier']),
      passengerMultiplier: _parseDouble(json['passenger_multiplier']),
      seasonalMultiplier: _parseDouble(json['seasonal_multiplier']),
      timeMultiplier: _parseDouble(json['time_multiplier']),
      subtotal: _parseDouble(json['subtotal']),
      extraFeesJson: (json['extra_fees_json'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      extraFeesTotal: _parseDouble(json['extra_fees_total']),
      finalPrice: _parseDouble(json['final_price']),
      currency: json['currency'] as String? ?? 'EUR',
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      customerPhone: json['customer_phone'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentMethod: json['payment_method'] as String?,
      assignedDriverId: json['assigned_driver'] as int?,
      assignedDriverInfo: json['assigned_driver_info'] != null
          ? DriverInfo.fromJson(json['assigned_driver_info'])
          : null,
      internalNotes: json['internal_notes'] as String?,
      dispatcherNotes: json['dispatcher_notes'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      confirmedAt: json['confirmed_at'] as String?,
      completedAt: json['completed_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return null;
  }

  bool get hasDriver => assignedDriverId != null;

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'В ожидании';
      case 'confirmed':
        return 'Подтверждено';
      case 'in_progress':
        return 'В пути';
      case 'completed':
        return 'Завершено';
      case 'cancelled':
        return 'Отменено';
      default:
        return status;
    }
  }

  String get paymentStatusDisplay {
    switch (paymentStatus) {
      case 'unpaid':
        return 'Не оплачено';
      case 'deposit_paid':
        return 'Депозит внесён';
      case 'fully_paid':
        return 'Оплачено';
      case 'refunded':
        return 'Возврат';
      default:
        return paymentStatus;
    }
  }
}

/// Dispatcher dashboard statistics.
class DispatcherStats {
  final int todayTransfers;
  final double todayRevenue;
  final int pendingCount;
  final int confirmedCount;
  final int inProgressCount;
  final int completedCount;
  final int cancelledCount;
  final int unassignedCount;
  final int unpaidCount;
  final int driversAvailable;
  final int driversTotal;

  const DispatcherStats({
    required this.todayTransfers,
    required this.todayRevenue,
    required this.pendingCount,
    required this.confirmedCount,
    required this.inProgressCount,
    required this.completedCount,
    required this.cancelledCount,
    required this.unassignedCount,
    required this.unpaidCount,
    required this.driversAvailable,
    required this.driversTotal,
  });

  factory DispatcherStats.fromJson(Map<String, dynamic> json) {
    return DispatcherStats(
      todayTransfers: json['today_transfers'] as int? ?? 0,
      todayRevenue: _parseDouble(json['today_revenue']),
      pendingCount: json['pending_count'] as int? ?? 0,
      confirmedCount: json['confirmed_count'] as int? ?? 0,
      inProgressCount: json['in_progress_count'] as int? ?? 0,
      completedCount: json['completed_count'] as int? ?? 0,
      cancelledCount: json['cancelled_count'] as int? ?? 0,
      unassignedCount: json['unassigned_count'] as int? ?? 0,
      unpaidCount: json['unpaid_count'] as int? ?? 0,
      driversAvailable: json['drivers_available'] as int? ?? 0,
      driversTotal: json['drivers_total'] as int? ?? 0,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}

/// Booking filter parameters.
class BookingFilters {
  final DateTime? date;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? status;
  final String? paymentStatus;
  final int? assignedDriver;
  final bool? unassigned;
  final String? search;

  const BookingFilters({
    this.date,
    this.dateFrom,
    this.dateTo,
    this.status,
    this.paymentStatus,
    this.assignedDriver,
    this.unassigned,
    this.search,
  });

  BookingFilters copyWith({
    DateTime? date,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? status,
    String? paymentStatus,
    int? assignedDriver,
    bool? unassigned,
    String? search,
    bool clearDate = false,
    bool clearStatus = false,
    bool clearPaymentStatus = false,
    bool clearDriver = false,
  }) {
    return BookingFilters(
      date: clearDate ? null : (date ?? this.date),
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      status: clearStatus ? null : (status ?? this.status),
      paymentStatus:
          clearPaymentStatus ? null : (paymentStatus ?? this.paymentStatus),
      assignedDriver:
          clearDriver ? null : (assignedDriver ?? this.assignedDriver),
      unassigned: unassigned ?? this.unassigned,
      search: search ?? this.search,
    );
  }

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (date != null) {
      params['date'] = _formatDate(date!);
    }
    if (dateFrom != null) {
      params['date_from'] = _formatDate(dateFrom!);
    }
    if (dateTo != null) {
      params['date_to'] = _formatDate(dateTo!);
    }
    if (status != null && status!.isNotEmpty) {
      params['status'] = status!;
    }
    if (paymentStatus != null && paymentStatus!.isNotEmpty) {
      params['payment_status'] = paymentStatus!;
    }
    if (assignedDriver != null) {
      params['assigned_driver'] = assignedDriver.toString();
    }
    if (unassigned == true) {
      params['unassigned'] = 'true';
    }
    if (search != null && search!.isNotEmpty) {
      params['search'] = search!;
    }
    return params;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool get hasActiveFilters =>
      date != null ||
      dateFrom != null ||
      dateTo != null ||
      (status != null && status!.isNotEmpty) ||
      (paymentStatus != null && paymentStatus!.isNotEmpty) ||
      assignedDriver != null ||
      unassigned == true ||
      (search != null && search!.isNotEmpty);
}
