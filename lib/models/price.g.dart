// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) {
  return Price()
    ..price = json['price'] as num
    ..doctorShare = json['doctor_share'] as num;
}

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'price': instance.price,
      'doctor_share': instance.doctorShare,
    };
