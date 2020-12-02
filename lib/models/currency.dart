import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency {
    Currency();

    String en;
    String ar;
    String symbol;
    
    factory Currency.fromJson(Map<String,dynamic> json) => _$CurrencyFromJson(json);
    Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
