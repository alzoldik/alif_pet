import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

@JsonSerializable()
class State {
  State();

  num id;
  String createdAt;
  String updatedAt;
  num countryId;
  String name;
  String nameAr;
  num sortOrder;
  num isActivated;

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);
  Map<String, dynamic> toJson() => _$StateToJson(this);
}
