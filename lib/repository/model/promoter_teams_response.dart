import 'package:json_annotation/json_annotation.dart';
part 'promoter_teams_response.g.dart';

@JsonSerializable()
class PromoterTeamsData{
  String? team;
  String? amount;
  String? image;

  PromoterTeamsData({this.team, this.amount, this.image});

  factory PromoterTeamsData.fromJson(Map<String, dynamic> json) => _$PromoterTeamsDataFromJson(json);
  Map<String, dynamic> toJson() => _$PromoterTeamsDataToJson(this);
}

@JsonSerializable()
class PromoterTeamsResponse{
  int? status;
  String? message;
  List<PromoterTeamsData>? result;

  PromoterTeamsResponse({this.status, this.message, this.result});

  factory PromoterTeamsResponse.fromJson(Map<String, dynamic> json) => _$PromoterTeamsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PromoterTeamsResponseToJson(this);

}