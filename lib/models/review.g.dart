// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return Review()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..doctorId = json['doctor_id'] as num
    ..clientId = json['client_id'] as num
    ..serviceRequestId = json['service_request_id'] as num
    ..rating = json['rating'] as num
    ..comment = json['comment'] as String;
}

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'doctor_id': instance.doctorId,
      'client_id': instance.clientId,
      'service_request_id': instance.serviceRequestId,
      'rating': instance.rating,
      'comment': instance.comment,
    };
