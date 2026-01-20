// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predefined_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredefinedLocation _$PredefinedLocationFromJson(Map<String, dynamic> json) =>
    PredefinedLocation(
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      type: json['type'] as String,
      typeDisplay: json['type_display'] as String,
    );
