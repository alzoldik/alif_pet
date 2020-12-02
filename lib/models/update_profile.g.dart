// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
Update_profile _$Update_profileFromJson(Map<String, dynamic> json) {
  return Update_profile()
    ..success = json['success'] == null
        ? null
        : Success.fromJson(json['success'] as Map<String, dynamic>)
    ..mobileMessage = json['mobileMessage'] as String
    ..emailMessage = json['emailMessage'] as String;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Update_profileToJson(Update_profile instance) =>
    <String, dynamic>{
      'success': instance.success,
      'mobileMessage': instance.mobileMessage,
      'emailMessage': instance.emailMessage,
    };
