import 'package:json_annotation/json_annotation.dart';
part 'invite_contest_response.g.dart';

@JsonSerializable()
class InviteContestData {
  int? status;
  Result? result;

  InviteContestData({this.status, this.result});

  factory InviteContestData.fromJson(Map<String, dynamic> json) => _$InviteContestDataFromJson(json);
  Map<String, dynamic> toJson() => _$InviteContestDataToJson(this);

}

@JsonSerializable()
class Result {
  List<ContestInvite>? contest;
  List<UsersMatches>? users_matches;
  List<int>? user_team_id;
  List<Teams>? teams;
  int? user_teams;
  int? joined_leagues;
  UserBalance? user_balance;
  String? sport_key;
  String? fantasy_type_id;

  Result(
      {this.contest,
        this.user_teams,
        this.joined_leagues,
        this.user_balance,
        this.sport_key,
        this.fantasy_type_id,
      this.users_matches,
      this.user_team_id});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);


}

@JsonSerializable()
class ContestInvite {
  int? id;
  int? challenge_id;
  String? name;
  String? challenge_type;
  int? winning_percentage;
  String? challenge_status;
  String? challenge_text;
  String? entryfee;
  String? winning_amount;
  int? win_amount;
  int? maximum_user;
  int? getjoinedpercentage;
  dynamic winners;
  int? userid;
  int? userrank;
  int? team_id;
  int? join_id;
  String? matchkey;
  int? joinedusers;
  String? team1display;
  String? team2display;
  int? multi_entry;
  int? confirmed_challenge;
  int? is_running;
  int? is_free;
  int? is_champion;
  String? champion_player;
  String? champion_x;
  int? is_offer_team;
  String? dis_price;
  int? is_bonus;
  int? is_gstbonus;
  String? bonus_percent;
  bool? isselected;
  String? isselectedid;
  int? joinedleagueskey;
  int? points;
  bool? isjoined;
  int? joinWith;
  String? refercode;
  dynamic totalwinners;
  int? first_rank_prize;
  int? user_joined_count;
  int? max_team_limit;
  int? max_multi_entry_user;
  String? pdf;
  String? is_giveaway_text;
  int? is_giveaway_visible_text;
  String? giveaway_color;
  String? announcement;
  int? is_gadget;
  int? is_flexible;
  int? is_join_similar_contest;
  int? myjoin_similar_contest;
  String? gadget_image;
  String? user_image;
  int? challenge_category_id;
  int? max_team_limit_exceeded_count;
  int? is_winning_zone;
  int? unlimited_credits_contest;

  ContestInvite(
      {this.id,
        this.challenge_id,
        this.name,
        this.challenge_type,
        this.winning_percentage,
        this.challenge_status,
        this.challenge_text,
        this.entryfee,
        this.winning_amount,
        this.win_amount,
        this.maximum_user,
        this.getjoinedpercentage,
        this.winners,
        this.userid,
        this.userrank,
        this.team_id,
        this.join_id,
        this.matchkey,
        this.joinedusers,
        this.team1display,
        this.team2display,
        this.multi_entry,
        this.confirmed_challenge,
        this.is_running,
        this.is_free,
        this.is_champion,
        this.champion_player,
        this.champion_x,
        this.is_offer_team,
        this.dis_price,
        this.is_bonus,
        this.is_gstbonus,
        this.bonus_percent,
        this.isselected,
        this.isselectedid,
        this.joinedleagueskey,
        this.points,
        this.isjoined,
        this.joinWith,
        this.refercode,
        this.totalwinners,
        this.first_rank_prize,
        this.user_joined_count,
        this.max_team_limit,
        this.max_multi_entry_user,
        this.pdf,
        this.is_giveaway_text,
        this.is_giveaway_visible_text,
        this.giveaway_color,
        this.announcement,
        this.is_gadget,
        this.is_flexible,
        this.is_join_similar_contest,
        this.myjoin_similar_contest,
        this.gadget_image,
        this.user_image,
        this.challenge_category_id,
        this.max_team_limit_exceeded_count,
        this.is_winning_zone,
        this.unlimited_credits_contest});

  factory ContestInvite.fromJson(Map<String, dynamic> json) => _$ContestInviteFromJson(json);
  Map<String, dynamic> toJson() => _$ContestInviteToJson(this);
}

@JsonSerializable()
class UserBalance {
  double? winning;
  dynamic balance;
  int? bonus;

  UserBalance({this.winning, this.balance, this.bonus});

  factory UserBalance.fromJson(Map<String, dynamic> json) => _$UserBalanceFromJson(json);
  Map<String, dynamic> toJson() => _$UserBalanceToJson(this);

}

@JsonSerializable()
class UsersMatches {
  int? id;
  String? name;
  String? short_name;
  String? time_diff;
  String? format;
  int? series;
  String? seriesname;
  String? toss;
  String? team1display;
  String? team2display;
  String? team1name;
  String? team2name;
  int? is_fav_pin_contest;
  String? matchkey;
  String? winnerstatus;
  String? launch_status;
  int? match_status_key;
  String? match_status;
  String? sport_key;
  int? joined_count;
  int? team_count;
  int? winning_total;
  int? total_earned;
  String? final_status;
  String? url;
  String? banner_image;
  String? team1logo;
  String? team2logo;
  int? lineup;
  String? matchindexing;
  String? start_date;
  String? time_start;
  String? highlights;
  int? is_leaderboard;
  String? team1_color;
  String? team2_color;
  int? is_fiveplusone;
  int? is_tenplusone;
  int? is_amount_show;
  int? secondinning;
  String? amount;
  int? fantasy_type_id;
  int? unlimited_credit_match;
  String? unlimited_credit_text;
  int? is_classic_format;
  int? is_fiveplusOne_format;
  int? is_TenplusOne_format;

  UsersMatches({this.id,
    this.name,
    this.short_name,
    this.time_diff,
    this.format,
    this.series,
    this.seriesname,
    this.toss,
    this.team1display,
    this.team2display,
    this.team1name,
    this.team2name,
    this.is_fav_pin_contest,
    this.matchkey,
    this.winnerstatus,
    this.launch_status,
    this.match_status_key,
    this.match_status,
    this.sport_key,
    this.joined_count,
    this.team_count,
    this.winning_total,
    this.total_earned,
    this.final_status,
    this.url,
    this.banner_image,
    this.team1logo,
    this.team2logo,
    this.lineup,
    this.matchindexing,
    this.start_date,
    this.time_start,
    this.highlights,
    this.is_leaderboard,
    this.team1_color,
    this.team2_color,
    this.is_fiveplusone,
    this.is_tenplusone,
    this.is_amount_show,
    this.secondinning,
    this.amount,
    this.fantasy_type_id,
    this.unlimited_credit_match,
    this.unlimited_credit_text,
    this.is_classic_format,
    this.is_fiveplusOne_format,
    this.is_TenplusOne_format});


  factory UsersMatches.fromJson(Map<String, dynamic> json) => _$UsersMatchesFromJson(json);
  Map<String, dynamic> toJson() => _$UsersMatchesToJson(this);

}


@JsonSerializable()
class Teams {
  int? teamnumber;
  int? teamid;
  int? points;
  String? matchkey;
  int? fantasy_type_id;
  String? fantasytype;
  String? team1_name;
  String? team2_name;
  int? is_joined;
  int? join_id;
  List<Players>? players;
  int? team1_player_count;
  int? team2_player_count;
  int? is_non_playing_players;
  String? is_non_playing_players_text;

  Teams({this.teamnumber,
    this.teamid,
    this.points,
    this.matchkey,
    this.fantasy_type_id,
    this.fantasytype,
    this.team1_name,
    this.team2_name,
    this.is_joined,
    this.join_id,
    this.players,
    this.team1_player_count,
    this.team2_player_count,
    this.is_non_playing_players,
    this.is_non_playing_players_text});

  factory Teams.fromJson(Map<String, dynamic> json) => _$TeamsFromJson(json);
  Map<String, dynamic> toJson() => _$TeamsToJson(this);
}

@JsonSerializable()
class Players {
  int? id;
  String? matchkey;
  String? name;
  String? role;
  String? short_role;
  String? display_role;
  String? credit;
  int? last_match;
  String? last_match_text;
  String? team;
  String? teamcode;
 // List<Null>? last_played_points;
  String? last_match_played_info_text;
  int? is_visible_last_match_played;
  String? teamcolor;
  String? image;
  int? vicecaptain;
  int? captain;
  int? points;
  int? is_playing;
  int? is_playing_show;
  String? series_points;
  String? selected_by;
  String? vice_captain_selected_by;
  String? captain_selected_by;
  String? batting_order;

  Players(
      {this.id,
        this.matchkey,
        this.name,
        this.role,
        this.short_role,
        this.display_role,
        this.credit,
        this.last_match,
        this.last_match_text,
        this.team,
        this.teamcode,
      //  this.last_played_points,
        this.last_match_played_info_text,
        this.is_visible_last_match_played,
        this.teamcolor,
        this.image,
        this.vicecaptain,
        this.captain,
        this.points,
        this.is_playing,
        this.is_playing_show,
        this.series_points,
        this.selected_by,
        this.vice_captain_selected_by,
        this.captain_selected_by,
        this.batting_order});

  factory Players.fromJson(Map<String, dynamic> json) => _$PlayersFromJson(json);
  Map<String, dynamic> toJson() => _$PlayersToJson(this);

}