// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return Service()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..doctorId = json['doctor_id'] as num
    ..serviceId = json['service_id'] as num
    ..price = json['price'] as num
    ..currencyEn = json['currency_en'] as String
    ..currencyAr = json['currency_ar'] as String
    ..currencySymbol = json['currency_symbol'] as String
    ..service = json['service'] == null
        ? null
        : Service_data.fromJson(json['service'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'doctor_id': instance.doctorId,
      'service_id': instance.serviceId,
      'price': instance.price,
      'currency_en': instance.currencyEn,
      'currency_ar': instance.currencyAr,
      'currency_symbol': instance.currencySymbol,
      'service': instance.service,
    };
