import 'package:json_annotation/json_annotation.dart';
part 'compare_team_response.g.dart';

@JsonSerializable()
class ComparePlayer {
  var team;
  var playercredit;
  var playerpoints;
  var team_id;
  int? pid;
  String? playerrole;
  String? role;
  String? playername;
  String? image;
  String? teamcode;

  ComparePlayer(
      {this.team,
      this.playercredit,
      this.playerpoints,
      this.team_id,
      this.pid,
      this.playerrole,
      this.role,
      this.playername,
      this.image,
      this.teamcode});

  factory ComparePlayer.fromJson(Map<String, dynamic> json) =>
      _$ComparePlayerFromJson(json);
  Map<String, dynamic> toJson() => _$ComparePlayerToJson(this);

  String getShortName() {
    if (playername!.isNotEmpty) {
      playername = playername!.trim();
      if (playername!.length > 0) {
        var names = playername!.split(" ");
        if (names.length > 1) {
          String fullName =
              names[0].substring(0, 1) + " " + names[names.length - 1];
          return fullName.length > 10
              ? fullName.substring(0, 10) + '...'
              : fullName;
        } else {
          return names[0];
        }
      } else {
        return playername!;
      }
    }

    return "";
  }
}

@JsonSerializable()
class TeamPlayers {
  List<ComparePlayer>? player_data;

  TeamPlayers({this.player_data});

  factory TeamPlayers.fromJson(Map<String, dynamic> json) =>
      _$TeamPlayersFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPlayersToJson(this);
}

@JsonSerializable()
class PlayerModel {
  String? diff_text;
  var diff_points;
  List<TeamPlayers>? data;

  PlayerModel({this.diff_text, this.diff_points, this.data});

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerModelToJson(this);
}

@JsonSerializable()
class CompareData {
  String? team1_name;
  String? team2_name;
  String? team1_rank;
  String? team2_rank;
  String? team1_image;
  String? team2_image;
  String? diff_text;
  var team1_points;
  var team2_points;
  var diff_points;
  List<PlayerModel>? player_list;

  CompareData(
      {this.team1_name,
      this.team2_name,
      this.team1_rank,
      this.team2_rank,
      this.team1_image,
      this.team2_image,
      this.diff_text,
      this.team1_points,
      this.team2_points,
      this.diff_points,
      this.player_list});

  factory CompareData.fromJson(Map<String, dynamic> json) =>
      _$CompareDataFromJson(json);
  Map<String, dynamic> toJson() => _$CompareDataToJson(this);
}

@JsonSerializable()
class CompareTeamResponse {
  int? status;
  String? message;
  CompareData? result;

  CompareTeamResponse({this.status, this.message, this.result});

  factory CompareTeamResponse.fromJson(Map<String, dynamic> json) =>
      _$CompareTeamResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CompareTeamResponseToJson(this);
}
