// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speciality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Speciality _$SpecialityFromJson(Map<String, dynamic> json) {
  return Speciality()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..name = json['name'] as String
    ..nameAr = json['name_ar'] as String
    ..sortOrder = json['sort_order'] as num
    ..isActivated = json['is_activated'] as num;
}

Map<String, dynamic> _$SpecialityToJson(Speciality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'sort_order': instance.sortOrder,
      'is_activated': instance.isActivated,
    };
