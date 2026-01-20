// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_fee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtraFee _$ExtraFeeFromJson(Map<String, dynamic> json) => ExtraFee(
  id: (json['id'] as num).toInt(),
  feeName: json['fee_name'] as String,
  feeCode: json['fee_code'] as String,
  feeType: $enumDecode(_$FeeTypeEnumMap, json['fee_type']),
  feeTypeDisplay: json['fee_type_display'] as String?,
  amount: ExtraFee._decimalFromJson(json['amount']),
  isOptional: json['is_optional'] as bool,
  displayOrder: (json['display_order'] as num).toInt(),
  description: json['description'] as String,
);

const _$FeeTypeEnumMap = {
  FeeType.flat: 'flat',
  FeeType.perItem: 'per_item',
  FeeType.percentage: 'percentage',
};
