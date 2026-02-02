import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/team_response.dart';
part 'player_list_response.g.dart';

@JsonSerializable()
class Limit{
  int? maxplayers;
  int? team_max_player;
  double? total_credits;

  Limit({this.maxplayers, this.team_max_player, this.total_credits});

  factory Limit.fromJson(Map<String, dynamic> json) => _$LimitFromJson(json);
  Map<String, dynamic> toJson() => _$LimitToJson(this);
}

@JsonSerializable()
class PlayerListResponse{
  int? status;
  int? is_visible_lineup;
  int? is_lineup_out;
  int? is_visible_uploadscreenshot;
  String? message;
  String? lineup_text;
  List<Player>? result;
  Limit? limit;


  PlayerListResponse({
    this.is_visible_lineup,
      this.status,
      this.is_lineup_out,
      this.is_visible_uploadscreenshot,
      this.message,
      this.lineup_text,
      this.result,
      this.limit});

  factory PlayerListResponse.fromJson(Map<String, dynamic> json) => _$PlayerListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerListResponseToJson(this);

}