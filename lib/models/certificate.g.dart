// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Certificate _$CertificateFromJson(Map<String, dynamic> json) {
  return Certificate()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..userId = json['user_id'] as num
    ..file = json['file'] as String;
}

Map<String, dynamic> _$CertificateToJson(Certificate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'file': instance.file,
    };
