// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_of_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
Service_of_request _$Service_of_requestFromJson(Map<String, dynamic> json) {
  return Service_of_request()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..name = json['name'] as String
    ..nameAr = json['name_ar'] as String
    ..method = json['method'] as String
    ..sortOrder = json['sort_order'] as num
    ..isActivated = json['is_activated'] as num
    ..prices = json['prices'] == null
        ? null
        : Price.fromJson(json['prices'] as Map<String, dynamic>);
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Service_of_requestToJson(Service_of_request instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'method': instance.method,
      'sort_order': instance.sortOrder,
      'is_activated': instance.isActivated,
      'prices': instance.prices,
    };
