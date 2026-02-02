import 'package:json_annotation/json_annotation.dart';
part 'create_team_response.g.dart';

@JsonSerializable()
class TeamResult{
  int? marathonstatus;
  int? teamid;
  int? teamcount;
  int? status;


  TeamResult({this.marathonstatus, this.teamid, this.teamcount, this.status});

  factory TeamResult.fromJson(Map<String, dynamic> json) => _$TeamResultFromJson(json);
  Map<String, dynamic> toJson() => _$TeamResultToJson(this);
}

@JsonSerializable()
class CreateTeamResponse{
  int? status;
  String? message;
  TeamResult? result;

  CreateTeamResponse({this.status, this.message, this.result});

  factory CreateTeamResponse.fromJson(Map<String, dynamic> json) => _$CreateTeamResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTeamResponseToJson(this);

}