import 'package:json_annotation/json_annotation.dart';
part 'player_points_response.g.dart';

@JsonSerializable()
class MultiSportsPlayerBreakPointItem {
  String? event_name;
  var actual;
  var actual_points;

  MultiSportsPlayerBreakPointItem(
      {this.event_name, this.actual, this.actual_points});

  factory MultiSportsPlayerBreakPointItem.fromJson(Map<String, dynamic> json) =>
      _$MultiSportsPlayerBreakPointItemFromJson(json);
  Map<String, dynamic> toJson() =>
      _$MultiSportsPlayerBreakPointItemToJson(this);
}

@JsonSerializable()
class MultiSportsPlayerPointItem {
  int? id;
  String? player_name;
  String? team;
  String? selected_by;
  String? captaind_by;
  String? points;
  String? image;
  String? role;
  String? short_name;
  int? isSelected;
  int? is_topplayer;
  List<MultiSportsPlayerBreakPointItem>? breakup_points;

  String? credit;

  MultiSportsPlayerPointItem(
      {this.id,
      this.player_name,
      this.team,
      this.selected_by,
      this.captaind_by,
      this.points,
      this.image,
      this.role,
      this.short_name,
      this.isSelected,
      this.is_topplayer,
      this.breakup_points,
      this.credit});

  factory MultiSportsPlayerPointItem.fromJson(Map<String, dynamic> json) =>
      _$MultiSportsPlayerPointItemFromJson(json);
  Map<String, dynamic> toJson() => _$MultiSportsPlayerPointItemToJson(this);
}

@JsonSerializable()
class PlayerPointsResponse {
  int? status;
  String? message;
  List<MultiSportsPlayerPointItem>? result;

  PlayerPointsResponse({this.status, this.message, this.result});

  factory PlayerPointsResponse.fromJson(Map<String, dynamic> json) =>
      _$PlayerPointsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerPointsResponseToJson(this);
}
