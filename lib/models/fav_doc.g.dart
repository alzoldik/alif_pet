// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fav_doc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
FavDoc _$Fav_docFromJson(Map<String, dynamic> json) {
  return FavDoc()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..doctorId = json['doctor_id'] as num
    ..clientId = json['client_id'] as num
    ..doctor = json['doctor'] == null
        ? null
        : Profile.fromJson(json['doctor'] as Map<String, dynamic>);
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Fav_docToJson(FavDoc instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'doctor_id': instance.doctorId,
      'client_id': instance.clientId,
      'doctor': instance.doctor,
    };
