import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  Review();

  num id;
  String createdAt;
  String updatedAt;
  num doctorId;
  num clientId;
  num serviceRequestId;
  num rating;
  String comment;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
