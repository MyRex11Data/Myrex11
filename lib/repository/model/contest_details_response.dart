import 'package:json_annotation/json_annotation.dart';
part 'contest_details_response.g.dart';

@JsonSerializable()
class JoinedContestTeam {
  String? userrank;
  String? team1display;
  int? totalwinners;
  var entryfee;
  int? getjoinedpercentage;
  int? joinedusers;
  int? is_running;
  int? join_with;
  int? confirmed_challenge;
  int? is_bonus;
  int? id;
  int? currentTeamCount;
  var win_amount;
  int? maximum_user;
  int? userid;
  int? challenge_id;
  int? team_id;
  int? join_id;
  dynamic is_winning_zone;
  bool? isjoined;
  bool? isselected;
  bool? isSelected;
  String? matchkey;
  var multi_entry;
  String? isselectedid;
  String? points;
  String? refercode;
  String? name;
  String? team2display;
  String? user_image;
  String? teamname;

  int? is_champion;

  JoinedContestTeam(
      {this.userrank,
      this.team1display,
      this.totalwinners,
      this.entryfee,
      this.getjoinedpercentage,
      this.joinedusers,
      this.is_running,
      this.join_with,
      this.confirmed_challenge,
      this.is_bonus,
      this.id,
      this.currentTeamCount,
      this.win_amount,
      this.maximum_user,
      this.userid,
      this.challenge_id,
      this.team_id,
      this.join_id,
      this.is_winning_zone,
      this.isjoined,
      this.isselected,
      this.isSelected,
      this.matchkey,
      this.multi_entry,
      this.isselectedid,
      this.points,
      this.refercode,
      this.name,
      this.team2display,
      this.user_image,
      this.teamname,
      this.is_champion});

  factory JoinedContestTeam.fromJson(Map<String, dynamic> json) =>
      _$JoinedContestTeamFromJson(json);
  Map<String, dynamic> toJson() => _$JoinedContestTeamToJson(this);

  String? getPoints() {
    return points;
    /*=='0'?points!:points!.contains(".00")?points!.replaceAll(".00","0"):points!.substring(points!.length - 1)=="0"?points!.substring(0,points!.length - 1):*/ points;
  }
}

@JsonSerializable()
class ContestDetailItem {
  List<JoinedContestTeam>? contest;
  dynamic totaljoin;

  ContestDetailItem({this.contest, this.totaljoin});

  factory ContestDetailItem.fromJson(Map<String, dynamic> json) =>
      _$ContestDetailItemFromJson(json);
  Map<String, dynamic> toJson() => _$ContestDetailItemToJson(this);
}

@JsonSerializable()
class ContestDetailResponse {
  int? status;
  String? message;
  dynamic pages_status;
  ContestDetailItem? result;

  ContestDetailResponse(
      {this.status, this.message, this.result, this.pages_status});

  factory ContestDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ContestDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContestDetailResponseToJson(this);
}
