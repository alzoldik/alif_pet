import 'package:json_annotation/json_annotation.dart';

part 'speciality.g.dart';

@JsonSerializable()
class Speciality {
  Speciality();

  num id;
  String createdAt;
  String updatedAt;
  String name;
  String nameAr;
  num sortOrder;
  num isActivated;

  factory Speciality.fromJson(Map<String, dynamic> json) =>
      _$SpecialityFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialityToJson(this);
}
