import 'package:json_annotation/json_annotation.dart';
import "success.dart";
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  LoginResponse();

  Success success;
  String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$Login_responseFromJson(json);
  Map<String, dynamic> toJson() => _$Login_responseToJson(this);
}
