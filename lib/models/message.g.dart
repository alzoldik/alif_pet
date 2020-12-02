// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..userId = json['user_id'] as num
    ..type = json['type'] as String
    ..message = json['message'] as String
    ..file = json['file'] as String
    ..serviceRequestId = json['service_request_id'] as num
    ..read = json['read'] as num
    ..user = json['user'] == null
        ? null
        : Profile.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'type': instance.type,
      'message': instance.message,
      'file': instance.file,
      'service_request_id': instance.serviceRequestId,
      'read': instance.read,
      'user': instance.user,
    };
