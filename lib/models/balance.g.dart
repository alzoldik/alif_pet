// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balance _$BalanceFromJson(Map<String, dynamic> json) {
  return Balance()
    ..balance = json['balance'] as num
    ..currency = json['currency'] == null
        ? null
        : Currency.fromJson(json['currency'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
      'balance': instance.balance,
      'currency': instance.currency,
    };
