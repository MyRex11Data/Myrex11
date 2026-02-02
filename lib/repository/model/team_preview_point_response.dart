import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/banner_response.dart';
import 'package:myrex11/repository/model/team_response.dart';
part 'team_preview_point_response.g.dart';

@JsonSerializable()
class TeamPointResponseItem {
  String? teamname;
  int? teamnumber;
  int? status;
  double? points;
  List<Player>? bowler;
  List<Player>? keeper;
  List<Player>? allrounder;
  List<Player>? batsman;
  List<Player>? Forward;
  List<Player>? Goalkeeper;
  List<Player>? Midfielder;
  List<Player>? Defender;
  List<Player>? Outfielder;
  List<Player>? Infielder;
  List<Player>? Pitcher;
  List<Player>? Catcher;

  @JsonKey(name: "Point guard")
  List<Player>? pgList;
  @JsonKey(name: "Shooting guard")
  List<Player>? sgList;
  @JsonKey(name: "Small forward")
  List<Player>? smallForwardList;
  @JsonKey(name: "Power forward")
  List<Player>? powerForwardList;
  @JsonKey(name: "Center")
  List<Player>? centreList;
  MatchDetails? match_details;

  TeamPointResponseItem(
      {this.teamname,
      this.teamnumber,
      this.status,
      this.points,
      this.bowler,
      this.keeper,
      this.allrounder,
      this.batsman,
      this.Forward,
      this.Goalkeeper,
      this.Midfielder,
      this.Defender,
      this.Outfielder,
      this.Infielder,
      this.Pitcher,
      this.Catcher,
      this.pgList,
      this.sgList,
      this.smallForwardList,
      this.powerForwardList,
      this.centreList,
      this.match_details});

  factory TeamPointResponseItem.fromJson(Map<String, dynamic> json) =>
      _$TeamPointResponseItemFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPointResponseItemToJson(this);
}

@JsonSerializable()
class TeamPointPreviewResponse {
  int? status;
  String? message;
  TeamPointResponseItem? result;

  TeamPointPreviewResponse({this.status, this.message, this.result});

  factory TeamPointPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$TeamPointPreviewResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPointPreviewResponseToJson(this);
}
