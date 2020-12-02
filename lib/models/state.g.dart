// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

State _$StateFromJson(Map<String, dynamic> json) {
  return State()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..countryId = json['country_id'] as num
    ..name = json['name'] as String
    ..nameAr = json['name_ar'] as String
    ..sortOrder = json['sort_order'] as num
    ..isActivated = json['is_activated'] as num;
}

Map<String, dynamic> _$StateToJson(State instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'country_id': instance.countryId,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'sort_order': instance.sortOrder,
      'is_activated': instance.isActivated,
    };
