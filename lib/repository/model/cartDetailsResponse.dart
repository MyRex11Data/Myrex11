import 'package:json_annotation/json_annotation.dart';
part 'cartDetailsResponse.g.dart';

@JsonSerializable()
class ContestCartResponse {
  int? status;
  String? message;
  int? total_cart_amount;
  int? low_balance;
  String? required_balance;
  String? template;
  List<ContestCartTeam>? result;

  ContestCartResponse(
      {this.status,
      this.message,
      this.total_cart_amount,
      this.low_balance,
      this.required_balance,
      this.template,
      this.result});

  factory ContestCartResponse.fromJson(Map<String, dynamic> json) =>
      _$ContestCartResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContestCartResponseToJson(this);
}

@JsonSerializable()
class ContestCartTeam {
  String? matchkey;
  String? team_id;
  String? team_text;
  int? total_amount;
  List<ContestCart>? contest;

  ContestCartTeam({
    this.matchkey,
    this.team_id,
    this.team_text,
    this.total_amount,
    this.contest,
  });

  factory ContestCartTeam.fromJson(Map<String, dynamic> json) =>
      _$ContestCartTeamFromJson(json);

  Map<String, dynamic> toJson() => _$ContestCartTeamToJson(this);
}

@JsonSerializable()
class ContestCart {
  int? id;
  int? challenge_id;
  String? name;
  String? challenge_type;
  int? winning_percentage;
  String? challenge_status;
  String? challenge_text;
  int? is_free_for_referrer;
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
  int? multi_entry;
  int? confirmed_challenge;
  int? is_running;
  int? is_free;
  int? is_bonus;
  String? bonus_percent;
  bool? isselected;
  bool? isjoined;
  int? first_rank_prize;
  String? pdf;
  int? challenge_category_id;
  int? quantity;

  ContestCart(
      {this.id,
      this.challenge_id,
      this.name,
      this.challenge_type,
      this.winning_percentage,
      this.challenge_status,
      this.challenge_text,
      this.is_free_for_referrer,
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
      this.multi_entry,
      this.confirmed_challenge,
      this.is_running,
      this.is_free,
      this.is_bonus,
      this.bonus_percent,
      this.isselected,
      this.isjoined,
      this.first_rank_prize,
      this.pdf,
      this.challenge_category_id,
      this.quantity});

  factory ContestCart.fromJson(Map<String, dynamic> json) =>
      _$ContestCartFromJson(json);

  Map<String, dynamic> toJson() => _$ContestCartToJson(this);
}
