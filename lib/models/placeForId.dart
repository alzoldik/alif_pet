import 'package:json_annotation/json_annotation.dart';

part 'placeForId.g.dart';

@JsonSerializable()
class PlaceForId {
  PlaceForId();

  List htmlAttributions;
  List results;
  String status;

  factory PlaceForId.fromJson(Map<String, dynamic> json) =>
      _$PlaceForIdFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceForIdToJson(this);
}
