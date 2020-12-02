import 'package:json_annotation/json_annotation.dart';

part 'service_data.g.dart';

@JsonSerializable()
// ignore: camel_case_types
class Service_data {
  Service_data();

  num id;
  String createdAt;
  String updatedAt;
  String name;
  String nameAr;
  String method;
  num sortOrder;
  num isActivated;

  factory Service_data.fromJson(Map<String, dynamic> json) =>
      _$Service_dataFromJson(json);
  Map<String, dynamic> toJson() => _$Service_dataToJson(this);
}
