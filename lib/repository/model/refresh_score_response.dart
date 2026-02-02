import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/team_response.dart';

part 'refresh_score_response.g.dart';

@JsonSerializable()
class LiveFinishedContestData {
  int? winingamount;
  int? is_private;
  var totalwinners;
  int? id;
  int? minimum_user;
  int? multi_entry;
  int? confirmed;
  int? teamid;
  int? userrank;
  int? maximum_user;
  int? can_invite;
  var entryfee;
  int? joinedusers;
  int? joinid;
  int? grand;
  int? team_number_get;
  int? win_amount;
  int? pdf_created;
  int? status;
  int? confirmed_challenge;
  int? is_bonus;
  int? max_multi_entry_user;
  String? refercode;
  var first_rank_prize;
  var points;
  String? matchstatus;
  String? challenge_type;
  var winning_percentage;
  String? pdf;
  String? join_with;
  String? name;
  var winning_amount;
  var getjoinedpercentage;
  String? bonus_percent;
  String? challenge_status;
  String? challenge_text;
  String? is_giveaway_text;
  String? giveaway_color;
  int? is_giveaway_visible_text;
  List<PriceCardItem>? recycler_item_price_card;
  List<WinnersZoneItem>? winners_zone;
  int? is_flexible;

  int? is_champion;
  String? champion_player;
  String? champion_x;
  int? is_gadget;
  String? gadget_image;

  LiveFinishedContestData(
      {this.winingamount,
      this.is_private,
      this.totalwinners,
      this.id,
      this.minimum_user,
      this.multi_entry,
      this.confirmed,
      this.teamid,
      this.userrank,
      this.maximum_user,
      this.can_invite,
      this.entryfee,
      this.joinedusers,
      this.joinid,
      this.grand,
      this.team_number_get,
      this.win_amount,
      this.pdf_created,
      this.status,
      this.confirmed_challenge,
      this.is_bonus,
      this.max_multi_entry_user,
      this.refercode,
      this.first_rank_prize,
      this.points,
      this.matchstatus,
      this.challenge_type,
      this.winning_percentage,
      this.pdf,
      this.join_with,
      this.name,
      this.winning_amount,
      this.getjoinedpercentage,
      this.bonus_percent,
      this.challenge_status,
      this.challenge_text,
      this.is_giveaway_text,
      this.giveaway_color,
      this.is_giveaway_visible_text,
      this.recycler_item_price_card,
      this.winners_zone,
      this.is_flexible,
      this.is_gadget,
      this.gadget_image,
      this.champion_player,
      this.champion_x,
      this.is_champion});

  factory LiveFinishedContestData.fromJson(Map<String, dynamic> json) =>
      _$LiveFinishedContestDataFromJson(json);

  Map<String, dynamic> toJson() => _$LiveFinishedContestDataToJson(this);
}

@JsonSerializable()
class WinnersZoneItem {
  int? rank;
  int? is_winningzone;
  int? team_id;
  var team_number;
  String? team_name;
  String? points;
  String? arrowname;
  String? amount;

  WinnersZoneItem(
      {this.rank,
      this.is_winningzone,
      this.team_id,
      this.team_number,
      this.team_name,
      this.points,
      this.arrowname,
      this.amount});

  factory WinnersZoneItem.fromJson(Map<String, dynamic> json) =>
      _$WinnersZoneItemFromJson(json);

  Map<String, dynamic> toJson() => _$WinnersZoneItemToJson(this);
}

@JsonSerializable()
class PriceCardItem {
  int? start_position;
  int? price;
  int? id;

  PriceCardItem({this.start_position, this.price, this.id});

  factory PriceCardItem.fromJson(Map<String, dynamic> json) =>
      _$PriceCardItemFromJson(json);

  Map<String, dynamic> toJson() => _$PriceCardItemToJson(this);
}

@JsonSerializable()
class LiveFinishedScoreItem {
  String? Team1;
  String? Team2;
  String? Team1_Totalovers;
  String? Team1_Totalruns;
  String? Team1_Totalwickets;
  String? Team2_Totalwickets;
  String? Team2_Totalovers;
  String? Team2_Totalruns;
  String? Winning_Status;

  LiveFinishedScoreItem(
      {this.Team1,
      this.Team2,
      this.Team1_Totalovers,
      this.Team1_Totalruns,
      this.Team1_Totalwickets,
      this.Team2_Totalwickets,
      this.Team2_Totalovers,
      this.Team2_Totalruns,
      this.Winning_Status});

  factory LiveFinishedScoreItem.fromJson(Map<String, dynamic> json) =>
      _$LiveFinishedScoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$LiveFinishedScoreItemToJson(this);
}

@JsonSerializable()
class LiveScoreByBall {
  List<Batsman>? batter;
  Bowler? bowl;
  List<String>? oversummeries;
  int? is_show_card;

  LiveScoreByBall(
      {this.batter, this.bowl, this.oversummeries, this.is_show_card});

  factory LiveScoreByBall.fromJson(Map<String, dynamic> json) =>
      _$LiveScoreByBallFromJson(json);
  Map<String, dynamic> toJson() => _$LiveScoreByBallToJson(this);
}

@JsonSerializable()
class Batsman {
  String? name;
  String? runs;
  int? onstrike;

  Batsman({this.name, this.runs});
  factory Batsman.fromJson(Map<String, dynamic> json) =>
      _$BatsmanFromJson(json);
  Map<String, dynamic> toJson() => _$BatsmanToJson(this);
}

@JsonSerializable()
class Bowler {
  String? name;
  String? runs;
  int? onstrike;

  Bowler({this.name, this.runs, this.onstrike});

  factory Bowler.fromJson(Map<String, dynamic> json) => _$BowlerFromJson(json);
  Map<String, dynamic> toJson() => _$BowlerToJson(this);
}

@JsonSerializable()
class RefreshScoreItem {
  String? late_declared_text;
  int? is_late_declared;
  int? user_teams;
  var total_profit;
  var total_winning;
  var total_investment;
  var match_status;
  int? show_popper;
  int? show_investment;
  List<LiveFinishedScoreItem>? matchruns;
  List<LiveFinishedContestData>? contest;
  List<Team>? teams;
  LiveScoreByBall? live_score_by_ball;

  RefreshScoreItem(
      {this.late_declared_text,
      this.is_late_declared,
      this.user_teams,
      this.total_profit,
      this.total_winning,
      this.total_investment,
      this.matchruns,
      this.contest,
      this.show_popper,
      this.show_investment,
      this.teams,
      this.match_status,
      this.live_score_by_ball});

  factory RefreshScoreItem.fromJson(Map<String, dynamic> json) =>
      _$RefreshScoreItemFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshScoreItemToJson(this);
}

@JsonSerializable()
class RefreshScoreResponse {
  int? status;
  String? message;
  RefreshScoreItem? result;

  RefreshScoreResponse({this.status, this.message, this.result});

  factory RefreshScoreResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshScoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshScoreResponseToJson(this);
}
