import 'package:json_annotation/json_annotation.dart';

part 'certificate.g.dart';

@JsonSerializable()
class Certificate {
  Certificate();

  num id;
  String createdAt;
  String updatedAt;
  num userId;
  String file;

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);
  Map<String, dynamic> toJson() => _$CertificateToJson(this);
}
