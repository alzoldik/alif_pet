import 'package:json_annotation/json_annotation.dart';
import "price.dart";
part 'service_of_request.g.dart';

@JsonSerializable()
// ignore: camel_case_types
class Service_of_request {
  Service_of_request();

  num id;
  String createdAt;
  String updatedAt;
  String name;
  String nameAr;
  String method;
  num sortOrder;
  num isActivated;
  Price prices;

  factory Service_of_request.fromJson(Map<String, dynamic> json) =>
      _$Service_of_requestFromJson(json);
  Map<String, dynamic> toJson() => _$Service_of_requestToJson(this);
}
