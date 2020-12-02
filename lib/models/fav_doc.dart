import 'package:json_annotation/json_annotation.dart';
import "profile.dart";
part 'fav_doc.g.dart';

@JsonSerializable()
class FavDoc {
  FavDoc();

  num id;
  String createdAt;
  String updatedAt;
  num doctorId;
  num clientId;
  Profile doctor;

  factory FavDoc.fromJson(Map<String, dynamic> json) => _$Fav_docFromJson(json);
  Map<String, dynamic> toJson() => _$Fav_docToJson(this);
}
