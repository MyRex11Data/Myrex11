import 'package:json_annotation/json_annotation.dart';
part 'sportsArray.g.dart';

@JsonSerializable()
class SportArr {
  String? sport_name;
  String? sport_key;

  SportArr({this.sport_name, this.sport_key});

  factory SportArr.fromJson(Map<String, dynamic> json) =>
      _$SportArrFromJson(json);
  Map<String, dynamic> toJson() => _$SportArrToJson(this);
}
