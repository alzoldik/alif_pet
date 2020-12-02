import 'package:json_annotation/json_annotation.dart';

part 'request_service_for_chat.g.dart';

@JsonSerializable()
// ignore: camel_case_types
class Request_service_for_chat {
  Request_service_for_chat();

  num doctorId;
  num serviceId;
  String date;
  String timeSlot;
  String description;

  factory Request_service_for_chat.fromJson(Map<String, dynamic> json) =>
      _$Request_service_for_chatFromJson(json);
  Map<String, dynamic> toJson() => _$Request_service_for_chatToJson(this);
}
