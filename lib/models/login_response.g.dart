// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// ignore: non_constant_identifier_names
LoginResponse _$Login_responseFromJson(Map<String, dynamic> json) {
  return LoginResponse()
    ..success = json['success'] == null
        ? null
        : Success.fromJson(json['success'] as Map<String, dynamic>)
    ..token = json['token'] as String;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _$Login_responseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
    };
