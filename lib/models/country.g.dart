// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country()
    ..id = json['id'] as num
    ..createdAt = json['created_at'] as String
    ..updatedAt = json['updated_at'] as String
    ..name = json['name'] as String
    ..nameAr = json['name_ar'] as String
    ..sortOrder = json['sort_order'] as num
    ..isActivated = json['is_activated'] as num
    ..currency = json['currency'] as String
    ..currencyAr = json['currency_ar'] as String
    ..currencySymbol = json['currency_symbol'] as String
    ..countryCode = json['country_code'] as num
    ..states = (json['states'] as List)
        ?.map(
            (e) => e == null ? null : State.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'sort_order': instance.sortOrder,
      'is_activated': instance.isActivated,
      'currency': instance.currency,
      'currency_ar': instance.currencyAr,
      'currency_symbol': instance.currencySymbol,
      'country_code': instance.countryCode,
      'states': instance.states,
    };
