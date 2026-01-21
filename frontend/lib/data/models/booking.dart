/// Booking list item model.
class BookingListItem {
  final int id;
  final String bookingReference;
  final String pickupAddress;
  final String dropoffAddress;
  final String serviceDate;
  final String pickupTime;
  final bool isRoundTrip;
  final String? returnDate;
  final String? returnTime;
  final String vehicleClassName;
  final double finalPrice;
  final String currency;
  final String status;
  final String paymentStatus;
  final String createdAt;

  const BookingListItem({
    required this.id,
    required this.bookingReference,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.serviceDate,
    required this.pickupTime,
    required this.isRoundTrip,
    this.returnDate,
    this.returnTime,
    required this.vehicleClassName,
    required this.finalPrice,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory BookingListItem.fromJson(Map<String, dynamic> json) {
    return BookingListItem(
      id: json['id'] as int,
      bookingReference: json['booking_reference'] as String,
      pickupAddress: json['pickup_address'] as String,
      dropoffAddress: json['dropoff_address'] as String,
      serviceDate: json['service_date'] as String,
      pickupTime: json['pickup_time'] as String,
      isRoundTrip: json['is_round_trip'] as bool? ?? false,
      returnDate: json['return_date'] as String?,
      returnTime: json['return_time'] as String?,
      vehicleClassName: json['vehicle_class_name'] as String,
      finalPrice: _parseDouble(json['final_price']),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

/// Booking detail model (full data).
class BookingDetail {
  final int id;
  final String bookingReference;
  // Route
  final String pickupAddress;
  final double? pickupLat;
  final double? pickupLng;
  final String dropoffAddress;
  final double? dropoffLat;
  final double? dropoffLng;
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
  // Vehicle
  final String vehicleClassName;
  final String? vehicleClassImage;
  // Flight & requests
  final String? flightNumber;
  final String? specialRequests;
  // Pricing
  final String pricingType;
  final double? distanceKm;
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
  // Timestamps
  final String createdAt;
  final String? confirmedAt;
  final String? completedAt;

  const BookingDetail({
    required this.id,
    required this.bookingReference,
    required this.pickupAddress,
    this.pickupLat,
    this.pickupLng,
    required this.dropoffAddress,
    this.dropoffLat,
    this.dropoffLng,
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
    required this.vehicleClassName,
    this.vehicleClassImage,
    this.flightNumber,
    this.specialRequests,
    required this.pricingType,
    this.distanceKm,
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
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
  });

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      id: json['id'] as int,
      bookingReference: json['booking_reference'] as String,
      pickupAddress: json['pickup_address'] as String,
      pickupLat: _parseDoubleNullable(json['pickup_lat']),
      pickupLng: _parseDoubleNullable(json['pickup_lng']),
      dropoffAddress: json['dropoff_address'] as String,
      dropoffLat: _parseDoubleNullable(json['dropoff_lat']),
      dropoffLng: _parseDoubleNullable(json['dropoff_lng']),
      serviceDate: json['service_date'] as String,
      pickupTime: json['pickup_time'] as String,
      isRoundTrip: json['is_round_trip'] as bool? ?? false,
      returnDate: json['return_date'] as String?,
      returnTime: json['return_time'] as String?,
      returnFlightNumber: json['return_flight_number'] as String?,
      numPassengers: json['num_passengers'] as int,
      numLargeLuggage: json['num_large_luggage'] as int,
      numSmallLuggage: json['num_small_luggage'] as int,
      hasChildren: json['has_children'] as bool,
      vehicleClassName: json['vehicle_class_name'] as String,
      vehicleClassImage: json['vehicle_class_image'] as String?,
      flightNumber: json['flight_number'] as String?,
      specialRequests: json['special_requests'] as String?,
      pricingType: json['pricing_type'] as String,
      distanceKm: _parseDoubleNullable(json['distance_km']),
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
      currency: json['currency'] as String,
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      customerPhone: json['customer_phone'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      createdAt: json['created_at'] as String,
      confirmedAt: json['confirmed_at'] as String?,
      completedAt: json['completed_at'] as String?,
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

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}

/// Response model for created booking.
class BookingResponse {
  final int id;
  final String bookingReference;
  final String pickupAddress;
  final String dropoffAddress;
  final String serviceDate;
  final String pickupTime;
  final int numPassengers;
  final int numLargeLuggage;
  final int numSmallLuggage;
  final String vehicleClassName;
  final String? flightNumber;
  final String? specialRequests;
  final double finalPrice;
  final String currency;
  final String status;
  final String paymentStatus;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String createdAt;

  const BookingResponse({
    required this.id,
    required this.bookingReference,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.serviceDate,
    required this.pickupTime,
    required this.numPassengers,
    required this.numLargeLuggage,
    required this.numSmallLuggage,
    required this.vehicleClassName,
    this.flightNumber,
    this.specialRequests,
    required this.finalPrice,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.createdAt,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      id: json['id'] as int,
      bookingReference: json['booking_reference'] as String,
      pickupAddress: json['pickup_address'] as String,
      dropoffAddress: json['dropoff_address'] as String,
      serviceDate: json['service_date'] as String,
      pickupTime: json['pickup_time'] as String,
      numPassengers: json['num_passengers'] as int,
      numLargeLuggage: json['num_large_luggage'] as int,
      numSmallLuggage: json['num_small_luggage'] as int,
      vehicleClassName: json['vehicle_class_name'] as String,
      flightNumber: json['flight_number'] as String?,
      specialRequests: json['special_requests'] as String?,
      finalPrice: _parseDouble(json['final_price']),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      customerPhone: json['customer_phone'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}
