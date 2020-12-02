import 'package:json_annotation/json_annotation.dart';
import "success.dart";
part 'update_profile.g.dart';

@JsonSerializable()
// ignore: camel_case_types
class Update_profile {
  Update_profile();

  Success success;
  String mobileMessage;
  String emailMessage;

  factory Update_profile.fromJson(Map<String, dynamic> json) =>
      _$Update_profileFromJson(json);
  Map<String, dynamic> toJson() => _$Update_profileToJson(this);
}
