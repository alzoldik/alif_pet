import 'package:json_annotation/json_annotation.dart';
import "service_data.dart";
part 'service.g.dart';

@JsonSerializable()
class Service {
  Service();

  num id;
  String createdAt;
  String updatedAt;
  num doctorId;
  num serviceId;
  num price;
  String currencyEn;
  String currencyAr;
  String currencySymbol;
  Service_data service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
