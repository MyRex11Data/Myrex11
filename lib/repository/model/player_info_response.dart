import 'package:json_annotation/json_annotation.dart';
part 'player_info_response.g.dart';

@JsonSerializable()
class PlayerInfoMatchesItem {
  String? matchdate;
  String? matchname;
  var total_points;
  String? selectper;
  String? short_name;
  String? playername;

  PlayerInfoMatchesItem(this.matchdate, this.matchname, this.total_points,
      this.selectper, this.short_name, this.playername);

  factory PlayerInfoMatchesItem.fromJson(Map<String, dynamic> json) =>
      _$PlayerInfoMatchesItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerInfoMatchesItemToJson(this);
}

@JsonSerializable()
class PlayerInfoResult {
  String? country;
  String? playerimage;
  String? teams;
  String? battingstyle;
  var total_points;
  var playerpoints;
  var playercredit;
  var per;
  String? playerrole;
  String? playerkey;
  String? bowlingstyle;
  String? dob;
  String? playername;
  int? match_played;
  String? selected_percent;
  List<PlayerInfoMatchesItem>? matches;

  PlayerInfoResult(
      {this.country,
      this.playerimage,
      this.teams,
      this.battingstyle,
      this.total_points,
      this.playerpoints,
      this.playercredit,
      this.per,
      this.playerrole,
      this.playerkey,
      this.bowlingstyle,
      this.dob,
      this.playername,
      this.matches,
      this.match_played,
      this.selected_percent});

  factory PlayerInfoResult.fromJson(Map<String, dynamic> json) =>
      _$PlayerInfoResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerInfoResultToJson(this);
}

@JsonSerializable()
class PLayerInfoResponse {
  int? status;
  String? message;
  PlayerInfoResult? result;

  PLayerInfoResponse({this.status, this.message, this.result});

  factory PLayerInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PLayerInfoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PLayerInfoResponseToJson(this);
}
