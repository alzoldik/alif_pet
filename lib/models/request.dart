import 'package:json_annotation/json_annotation.dart';
import "profile.dart";
import "service_data.dart";
part 'request.g.dart';

@JsonSerializable()
class Request {
  Request();

  num id;
  String createdAt;
  String updatedAt;
  num clientAd;
  num doctorId;
  String serviceId;
  String date;
  num timeSlot;
  String description;
  String address;
  num latitude;
  num longitude;
  num status;
  String cancellationReason;
  num cost;
  num doctorShare;
  Map<String, dynamic> statusName;
  Map<String, dynamic> timeSlotName;
  Map<String, dynamic> currency;
  Profile doctor;
  Profile client;
  Service_data service;

  factory Request.fromJson(Map<String, dynamic> json) =>
      _$RequestFromJson(json);
  Map<String, dynamic> toJson() => _$RequestToJson(this);
}
