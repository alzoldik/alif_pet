import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class Error {
    Error();

    Map<String,dynamic> error;
    
    factory Error.fromJson(Map<String,dynamic> json) => _$ErrorFromJson(json);
    Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
