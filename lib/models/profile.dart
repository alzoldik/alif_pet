import 'package:json_annotation/json_annotation.dart';
import "certificate.dart";
import "country.dart";
import "state.dart";
import "speciality.dart";
import "service.dart";
import "review.dart";
part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile();

  num id;
  String name;
  String email;
  String ltevcs;
  num evcSentCount;
  String emailVerifiedAt;
  String mobile;
  String ltmvcs;
  num mvcSentCount;
  String mobileVerifiedAt;
  String language;
  String photo;
  num role;
  num active;
  String ltprcs;
  num prcSentCount;
  num countryId;
  num stateId;
  String address;
  String qualifications;
  num specialityId;
  String workDays;
  num workHoursFrom;
  num workhoursTo;
  String createdAt;
  String updatedAt;
  String roleName;
  num rating;
  bool favorite;
  dynamic workDaysNames;
  Map<String, dynamic> workHoursStr;
  List<Certificate> certificates;
  Country country;
  State state;
  Speciality speciality;
  List<Service> services;
  List<Review> reviews;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
