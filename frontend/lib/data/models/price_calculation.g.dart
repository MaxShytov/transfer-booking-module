// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_calculation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppliedExtraFee _$AppliedExtraFeeFromJson(Map<String, dynamic> json) =>
    AppliedExtraFee(
      feeCode: json['fee_code'] as String,
      feeName: json['fee_name'] as String,
      feeType: json['fee_type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitAmount: AppliedExtraFee._decimalFromJson(json['unit_amount']),
      totalAmount: AppliedExtraFee._decimalFromJson(json['total_amount']),
    );

PriceCalculation _$PriceCalculationFromJson(
  Map<String, dynamic> json,
) => PriceCalculation(
  routeType: json['route_type'] as String,
  routeName: json['route_name'] as String?,
  distanceKm: PriceCalculation._decimalFromJson(json['distance_km']),
  basePrice: PriceCalculation._decimalFromJson(json['base_price']),
  vehicleClass: json['vehicle_class'] == null
      ? null
      : VehicleClass.fromJson(json['vehicle_class'] as Map<String, dynamic>),
  vehicleMultiplier: PriceCalculation._decimalFromJson(
    json['vehicle_multiplier'],
  ),
  vehicleMultiplierLabel: json['vehicle_multiplier_label'] as String,
  seasonalMultiplier: PriceCalculation._decimalFromJson(
    json['seasonal_multiplier'],
  ),
  seasonalMultiplierLabel: json['seasonal_multiplier_label'] as String,
  passengerMultiplier: PriceCalculation._decimalFromJson(
    json['passenger_multiplier'],
  ),
  passengerMultiplierLabel: json['passenger_multiplier_label'] as String,
  timeMultiplier: PriceCalculation._decimalFromJson(json['time_multiplier']),
  timeMultiplierLabel: json['time_multiplier_label'] as String,
  subtotal: PriceCalculation._decimalFromJson(json['subtotal']),
  isRoundTrip: json['is_round_trip'] as bool,
  roundTripMultiplier: PriceCalculation._nullableDecimalFromJson(
    json['round_trip_multiplier'],
  ),
  roundTripDiscountLabel: json['round_trip_discount_label'] as String?,
  returnDate: json['return_date'] as String?,
  returnTime: json['return_time'] as String?,
  extraFees: (json['extra_fees'] as List<dynamic>)
      .map((e) => AppliedExtraFee.fromJson(e as Map<String, dynamic>))
      .toList(),
  extraFeesTotal: PriceCalculation._decimalFromJson(json['extra_fees_total']),
  finalPrice: PriceCalculation._decimalFromJson(json['final_price']),
  currency: json['currency'] as String,
  showBreakdown: json['show_breakdown'] as bool,
);
