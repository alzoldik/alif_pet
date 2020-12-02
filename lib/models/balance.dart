import 'package:json_annotation/json_annotation.dart';
import "currency.dart";
part 'balance.g.dart';

@JsonSerializable()
class Balance {
    Balance();

    num balance;
    Currency currency;
    
    factory Balance.fromJson(Map<String,dynamic> json) => _$BalanceFromJson(json);
    Map<String, dynamic> toJson() => _$BalanceToJson(this);
}
