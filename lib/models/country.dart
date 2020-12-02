import 'package:json_annotation/json_annotation.dart';
import "state.dart";
part 'country.g.dart';

@JsonSerializable()
class Country {
  Country();

  num id;
  String createdAt;
  String updatedAt;
  String name;
  String nameAr;
  num sortOrder;
  num isActivated;
  String currency;
  String currencyAr;
  String currencySymbol;
  num countryCode;
  List<State> states;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
