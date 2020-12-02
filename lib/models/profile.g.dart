// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile()
    ..id = json['id'] as num
    ..name = json['name'] as String
    ..email = json['email'] as String
    ..ltevcs = json['ltevcs'] as String
    ..evcSentCount = json['evc_sent_count'] as num
    ..emailVerifiedAt = json['email_verified_at'] as String
    ..mobile = json['mobile'] as String
    ..ltmvcs = json['ltmvcs'] as String
    ..mvcSentCount = json['mvc_sent_count'] as num
    ..mobileVerifiedAt = json['mobile_verified_at'] as String
    ..language = json['language'] as String
    ..photo = json['photo'] as String
    ..role = json['role'] as num
    ..active = json['active'] as num
    ..ltprcs = json['ltprcs'] as String
    ..prcSentCount = json['prc_sent_count'] as num
    ..countryId = json['country_id'] as num
    ..stateId = json['state_id'] as num
    ..address = json['address'] as String
    ..qualifications = json['qualifications'] as String
    ..specialityId = json['speciality_id'] as num
    ..workDays = json['work_days'] as String
    ..workHoursFrom = json['work_hours_from'] as num
    ..workhoursTo = json['work_hours_to'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..roleName = json['roleName'] as String
    ..rating = json['rating'] as num
    ..favorite = json['favorite'] as bool
    ..workDaysNames = json['workDaysNames']
    ..workHoursStr = json['workHoursStr'] as Map<String, dynamic>
    ..certificates = (json['certificates'] as List)
        ?.map((e) =>
            e == null ? null : Certificate.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..country = json['country'] == null
        ? null
        : Country.fromJson(json['country'] as Map<String, dynamic>)
    ..state = json['state'] == null
        ? null
        : State.fromJson(json['state'] as Map<String, dynamic>)
    ..speciality = json['speciality'] == null
        ? null
        : Speciality.fromJson(json['speciality'] as Map<String, dynamic>)
    ..services = (json['services'] as List)
        ?.map((e) =>
            e == null ? null : Service.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..reviews = (json['reviews'] as List)
        ?.map((e) =>
            e == null ? null : Review.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'ltevcs': instance.ltevcs,
      'evc_sent_count': instance.evcSentCount,
      'email_verified_at': instance.emailVerifiedAt,
      'mobile': instance.mobile,
      'ltmvcs': instance.ltmvcs,
      'mvc_sent_count': instance.mvcSentCount,
      'mobile_verified_at': instance.mobileVerifiedAt,
      'language': instance.language,
      'photo': instance.photo,
      'role': instance.role,
      'active': instance.active,
      'ltprcs': instance.ltprcs,
      'prc_sent_count': instance.prcSentCount,
      'country_id': instance.countryId,
      'state_id': instance.stateId,
      'address': instance.address,
      'qualifications': instance.qualifications,
      'speciality_id': instance.specialityId,
      'work_days': instance.workDays,
      'work_hours_from': instance.workHoursFrom,
      'work_hours_to': instance.workhoursTo,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'roleName': instance.roleName,
      'rating': instance.rating,
      'favorite': instance.favorite,
      'workDaysNames': instance.workDaysNames,
      'workHoursStr': instance.workHoursStr,
      'certificates': instance.certificates,
      'country': instance.country,
      'state': instance.state,
      'speciality': instance.speciality,
      'services': instance.services,
      'reviews': instance.reviews,
    };
