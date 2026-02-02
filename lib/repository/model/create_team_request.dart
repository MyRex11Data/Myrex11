
import 'package:json_annotation/json_annotation.dart';
part 'create_team_request.g.dart';
@JsonSerializable()
class CreateTeamRequest {
  String? matchkey;
  String? userid;
  String? players;
  String? vicecaptain;
  String? captain;
  String? sport_key;
  String? fantasy_type;
  String? slotes_id;
  String? fantasy_type_id;
  int? teamid;


  CreateTeamRequest({
      this.matchkey,
      this.userid,
      this.players,
      this.vicecaptain,
      this.captain,
      this.sport_key,
      this.fantasy_type,
      this.slotes_id,
      this.teamid,
  this.fantasy_type_id});

  factory CreateTeamRequest.fromJson(Map<String, dynamic> json) => _$CreateTeamRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTeamRequestToJson(this);
}

