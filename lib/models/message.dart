import 'package:json_annotation/json_annotation.dart';
import "profile.dart";
part 'message.g.dart';

@JsonSerializable()
class Message {
  Message();

  num id;
  String createdAt;
  String updatedAt;
  num userId;
  String type;
  String message;
  String file;
  num serviceRequestId;
  num read;
  Profile user;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
