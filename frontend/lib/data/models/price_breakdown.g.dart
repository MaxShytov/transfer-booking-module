// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceBreakdown _$PriceBreakdownFromJson(Map<String, dynamic> json) =>
    PriceBreakdown(
      pricingType: json['pricing_type'] as String,
      basePrice: (json['base_price'] as num).toDouble(),
      routeName: json['route_name'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      vehicleMultiplier: (json['vehicle_multiplier'] as num).toDouble(),
      vehicleClassName: json['vehicle_class_name'] as String,
      passengerMultiplier: (json['passenger_multiplier'] as num).toDouble(),
      passengerCount: (json['passenger_count'] as num).toInt(),
      seasonalMultiplier: (json['seasonal_multiplier'] as num).toDouble(),
      seasonName: json['season_name'] as String?,
      timeMultiplier: (json['time_multiplier'] as num).toDouble(),
      timeSlotName: json['time_slot_name'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      extraFees: (json['extra_fees'] as List<dynamic>)
          .map((e) => ExtraFeeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraFeesTotal: (json['extra_fees_total'] as num).toDouble(),
      finalPrice: (json['final_price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
    );

ExtraFeeItem _$ExtraFeeItemFromJson(Map<String, dynamic> json) => ExtraFeeItem(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  total: (json['total'] as num).toDouble(),
);
