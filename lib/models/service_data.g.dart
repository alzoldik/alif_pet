// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
Service_data _$Service_dataFromJson(Map<String, dynamic> json) {
  return Service_data()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..name = json['name'] as String
    ..nameAr = json['name_ar'] as String
    ..method = json['method'] as String
    ..sortOrder = json['sort_order'] as num
    ..isActivated = json['is_activated'] as num;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Service_dataToJson(Service_data instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'method': instance.method,
      'sort_order': instance.sortOrder,
      'is_activated': instance.isActivated,
    };
