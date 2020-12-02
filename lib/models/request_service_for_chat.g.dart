// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_service_for_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
Request_service_for_chat _$Request_service_for_chatFromJson(
    Map<String, dynamic> json) {
  return Request_service_for_chat()
    ..doctorId = json['doctor_id'] as num
    ..serviceId = json['service_id'] as num
    ..date = json['date'] as String
    ..timeSlot = json['time_slot'] as String
    ..description = json['description'] as String;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Request_service_for_chatToJson(
        Request_service_for_chat instance) =>
    <String, dynamic>{
      'doctor_id': instance.doctorId,
      'service_id': instance.serviceId,
      'date': instance.date,
      'time_slot': instance.timeSlot,
      'description': instance.description,
    };
