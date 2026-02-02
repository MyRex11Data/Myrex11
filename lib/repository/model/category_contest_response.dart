import 'package:json_annotation/json_annotation.dart';
part 'category_contest_response.g.dart';

@JsonSerializable()
class Contest {
  dynamic entryfee;
  dynamic first_rank_prize;
  dynamic getjoinedpercentage;
  String? dis_price;
  int? is_fav_pin_contest;
  String? challenge_type;
  String? matchkey;
  String? isselectedid;
  String? refercode;
  String? name;
  dynamic bonus_percent;
  String? pdf;
  String? announcement;
  int? first_time_free_amount;
  int? winning_percentage;
  dynamic totalwinners;
  int? joinedusers;

  int? is_free;
  int? multi_entry;
  int? is_running;
  int? confirmed_challenge;
  int? is_bonus;
  int? is_gstbonus;
  int? id;
  int? win_amount;
  int? maximum_user;
  int? status;
  int? real_entry_fees;
  int? max_multi_entry_user;
  int? is_flexible;
  dynamic is_fav_contest;
  int? is_fav_visible;
  int? real_challenge_id;
  int? challenge_id;
  int? is_first_time_free;
  bool? isjoined;
  bool? isselected;
  String? is_giveaway_text;
  String? giveaway_color;
  int? is_giveaway_visible_text;
  int? is_offer_team;
  int? is_gadget;
  int? is_champion;
  String? champion_player;
  String? champion_x;
  String? gadget_image;
  int? is_join_similar_contest;
  int? max_team_limit_exceeded_count;
  int? fantasy_type_id;
  int? is_free_for_referrer;
  int? is_free_for_me;
  int? allow_in_ban_state;
  var is_selected;
  int? quantity;

  Contest({
    this.is_gstbonus,
    this.challenge_id,
    this.entryfee,
    this.first_rank_prize,
    this.getjoinedpercentage,
    this.dis_price,
    this.challenge_type,
    this.real_entry_fees,
    this.matchkey,
    this.isselectedid,
    this.refercode,
    this.is_fav_pin_contest,
    this.name,
    this.bonus_percent,
    this.pdf,
    this.announcement,
    this.first_time_free_amount,
    this.winning_percentage,
    this.totalwinners,
    this.joinedusers,
    this.is_free,
    this.multi_entry,
    this.is_running,
    this.confirmed_challenge,
    this.is_bonus,
    this.id,
    this.win_amount,
    this.maximum_user,
    this.status,
    this.max_multi_entry_user,
    this.is_flexible,
    this.is_fav_contest,
    this.is_fav_visible,
    this.real_challenge_id,
    this.is_first_time_free,
    this.isjoined,
    this.isselected,
    this.is_giveaway_text,
    this.giveaway_color,
    this.is_giveaway_visible_text,
    this.max_team_limit_exceeded_count,
    this.is_champion,
    this.champion_x,
    this.champion_player,
    this.gadget_image,
    this.is_offer_team,
    this.is_gadget,
    this.is_join_similar_contest,
    this.fantasy_type_id,
    this.is_free_for_referrer,
    this.is_free_for_me,
    this.allow_in_ban_state,
    this.is_selected,
    this.quantity,
  });

  factory Contest.fromJson(Map<String, dynamic> json) =>
      _$ContestFromJson(json);
  Map<String, dynamic> toJson() => _$ContestToJson(this);

  int getLeftSpots() {
    return maximum_user!;
    //  maximum_user! - joinedusers!;
  }

  double totalWinners() {
    return double.parse(totalwinners.toString());
  }
}

@JsonSerializable()
class CategoriesItem {
  String? contest_sub_text;
  String? contest_type_image;
  String? contest_image_url;
  String? name;
  int? id;
  int? total_category_leagues;
  int? sort_order;
  int? status;
  int? is_view_more;
  List<Contest>? leagues;

  CategoriesItem(
      {this.contest_sub_text,
      this.contest_type_image,
      this.contest_image_url,
      this.name,
      this.id,
      this.total_category_leagues,
      this.sort_order,
      this.status,
      this.is_view_more,
      this.leagues});

  factory CategoriesItem.fromJson(Map<String, dynamic> json) =>
      _$CategoriesItemFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesItemToJson(this);
}

@JsonSerializable()
class CategoryModel {
  int? total_contest;
  int? user_teams;
  int? team_id;
  int? joined_leagues;
  dynamic private_contest_size_text;
  dynamic private_contest_winning_size_text;
  dynamic private_contest_size_max;
  dynamic private_contest_size_min;
  dynamic private_contest_winning_size_max;
  dynamic private_contest_winning_size_min;
  List<CategoriesItem>? categories;

  CategoryModel(
      {this.total_contest,
      this.user_teams,
      this.team_id,
      this.joined_leagues,
      this.categories,
      this.private_contest_size_text,
      this.private_contest_winning_size_text,
      this.private_contest_size_max,
      this.private_contest_size_min,
      this.private_contest_winning_size_max,
      this.private_contest_winning_size_min});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class CategoryByContestResponse {
  int? status;
  String? message;
  CategoryModel? result;

  CategoryByContestResponse({this.status, this.message, this.result});

  factory CategoryByContestResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryByContestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryByContestResponseToJson(this);
}
