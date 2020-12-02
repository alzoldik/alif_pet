// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..clientAd = json['client_id'] as num
    ..doctorId = json['doctor_id'] as num
    ..serviceId = json['service_id'] as String
    ..date = json['date'] as String
    ..timeSlot = json['time_slot'] as num
    ..description = json['description'] as String
    ..address = json['address'] as String
    ..latitude = json['latitude'] as num
    ..longitude = json['longitude'] as num
    ..status = json['status'] as num
    ..cancellationReason = json['cancellation_reason'] as String
    ..cost = json['cost'] as num
    ..doctorShare = json['doctor_share'] as num
    ..statusName = json['statusName'] as Map<String, dynamic>
    ..timeSlotName = json['timeSlotName'] as Map<String, dynamic>
    ..currency = json['currency'] as Map<String, dynamic>
    ..doctor = json['doctor'] == null
        ? null
        : Profile.fromJson(json['doctor'] as Map<String, dynamic>)
    ..client = json['client'] == null
        ? null
        : Profile.fromJson(json['client'] as Map<String, dynamic>)
    ..service = json['service'] == null
        ? null
        : Service_data.fromJson(json['service'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RequestToJson(Request instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'client_id': instance.clientAd,
      'doctor_id': instance.doctorId,
      'service_id': instance.serviceId,
      'date': instance.date,
      'time_slot': instance.timeSlot,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'cancellation_reason': instance.cancellationReason,
      'cost': instance.cost,
      'doctor_share': instance.doctorShare,
      'statusName': instance.statusName,
      'timeSlotName': instance.timeSlotName,
      'currency': instance.currency,
      'doctor': instance.doctor,
      'client': instance.client,
      'service': instance.service,
    };
