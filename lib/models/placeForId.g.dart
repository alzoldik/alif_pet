// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placeForId.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceForId _$PlaceForIdFromJson(Map<String, dynamic> json) {
  return PlaceForId()
    ..htmlAttributions = json['html_attributions'] as List
    ..results = json['results'] as List
    ..status = json['status'] as String;
}

Map<String, dynamic> _$PlaceForIdToJson(PlaceForId instance) =>
    <String, dynamic>{
      'html_attributions': instance.htmlAttributions,
      'results': instance.results,
      'status': instance.status,
    };
