// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) {
  return Blog()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..title = json['title'] as String
    ..body = json['body'] as String
    ..image = json['image'] as String
    ..isActivated = json['is_activated'] as num;
}

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'title': instance.title,
      'body': instance.body,
      'image': instance.image,
      'is_activated': instance.isActivated,
    };
