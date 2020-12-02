// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return Currency()
    ..en = json['en'] as String
    ..ar = json['ar'] as String
    ..symbol = json['symbol'] as String;
}

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'en': instance.en,
      'ar': instance.ar,
      'symbol': instance.symbol,
    };
