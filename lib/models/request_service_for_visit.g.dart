// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_service_for_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
Request_service_for_visit _$Request_service_for_visitFromJson(
    Map<String, dynamic> json) {
  return Request_service_for_visit()
    ..doctorId = json['doctor_id'] as num
    ..serviceId = json['service_id'] as num
    ..date = json['date'] as String
    ..timeSlot = json['time_slot'] as String
    ..description = json['description'] as String
    ..address = json['address'] as String
    ..latitude = json['latitude'] as num
    ..longitude = json['longitude'] as num;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Request_service_for_visitToJson(
        Request_service_for_visit instance) =>
    <String, dynamic>{
      'doctor_id': instance.doctorId,
      'service_id': instance.serviceId,
      'date': instance.date,
      'time_slot': instance.timeSlot,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
