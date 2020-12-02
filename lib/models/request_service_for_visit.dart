import 'package:json_annotation/json_annotation.dart';

part 'request_service_for_visit.g.dart';

@JsonSerializable()
// ignore: camel_case_types
class Request_service_for_visit {
  Request_service_for_visit();

  num doctorId;
  num serviceId;
  String date;
  String timeSlot;
  String description;
  String address;
  num latitude;
  num longitude;

  factory Request_service_for_visit.fromJson(Map<String, dynamic> json) =>
      _$Request_service_for_visitFromJson(json);
  Map<String, dynamic> toJson() => _$Request_service_for_visitToJson(this);
}
