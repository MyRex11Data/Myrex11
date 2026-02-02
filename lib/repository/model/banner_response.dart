import 'package:json_annotation/json_annotation.dart';
part 'banner_response.g.dart';

@JsonSerializable()
class BannerListItem {
  int? id;
  String? image;
  String? title;
  String? link;
  String? type;
  String? offer_code;
  var series_id;
  MatchDetails? match_details;

  BannerListItem({
    this.id,
    this.image,
    this.title,
    this.link,
    this.type,
    this.offer_code,
    this.series_id,
    this.match_details,
  });

  factory BannerListItem.fromJson(Map<String, dynamic> json) =>
      _$BannerListItemFromJson(json);
  Map<String, dynamic> toJson() => _$BannerListItemToJson(this);
}

@JsonSerializable()
class MatchDetails {
  int? id;
  int? series;
  int? match_status_key;
  int? joined_count;
  int? team_count;
  var winning_total;
  int? lineup;
  int? is_fav_pin_contest;
  int? is_leaderboard;
  int? is_amount_show;
  String? name;
  String? short_name;
  String? format;
  String? seriesname;
  String? toss;
  String? team1display;
  String? team2display;
  String? team1name;
  String? team2name;
  String? matchkey;
  String? winnerstatus;
  String? launch_status;
  String? match_status;
  int? sort_key;
  String? sport_key;
  String? final_status;
  String? url;
  String? banner_image;
  String? team1logo;
  String? team2logo;
  String? matchopenstatus;
  String? matchindexing;
  String? start_date;
  String? match_time;
  String? time_start;
  String? mega_contest_prize;
  var highlights;
  String? team1_color;
  String? team2_color;
  var amount;
  dynamic total_earned;
  String? giveaway_amount;
  int? is_visible_total_earned;
  int? is_giveaway_visible;
  int? reversefantasy;
  int? secondinning;
  int? bowlingfantasy;
  int? battingfantasy;
  int? livefantasy;
  int? is_fixture;
  Locktime? locktime;
  List<Slots>? slotes;
  int? unlimited_credit_match;
  String? unlimited_credit_text;
  bool? isaccountverified;
  dynamic is_classic_format;
  dynamic is_fiveplusOne_format;
  dynamic is_TenplusOne_format;
  String? team1player_image;
  String? team2player_image;
  String? match_date;
  int? is_giveaway;
  String? giveaway_heading;
  int? team_id;
  int? user_teams;
  int? is_notification_subscribed;

  MatchDetails(
      {this.id,
      this.series,
      this.match_status_key,
      this.joined_count,
      this.team_count,
      this.winning_total,
      this.lineup,
      this.is_leaderboard,
      this.is_amount_show,
      this.name,
      this.short_name,
      this.format,
      this.seriesname,
      this.toss,
      this.team1display,
      this.team2display,
      this.team1name,
      this.team2name,
      this.matchkey,
      this.winnerstatus,
      this.launch_status,
      this.match_status,
      this.sort_key,
      this.sport_key,
      this.final_status,
      this.url,
      this.banner_image,
      this.team1logo,
      this.team2logo,
      this.matchopenstatus,
      this.matchindexing,
      this.start_date,
      this.mega_contest_prize,
      this.time_start,
      this.highlights,
      this.team1_color,
      this.team2_color,
      this.amount,
      this.match_time,
      this.total_earned,
      this.giveaway_amount,
      this.is_visible_total_earned,
      this.is_giveaway_visible,
      this.reversefantasy,
      this.secondinning,
      this.bowlingfantasy,
      this.battingfantasy,
      this.livefantasy,
      this.is_fixture,
      this.locktime,
      this.slotes,
      this.unlimited_credit_match,
      this.is_fav_pin_contest,
      this.unlimited_credit_text,
      this.isaccountverified,
      this.is_TenplusOne_format,
      this.is_fiveplusOne_format,
      this.is_classic_format,
      this.team1player_image,
      this.team2player_image,
      this.match_date,
      this.is_giveaway,
      this.giveaway_heading,
      this.team_id,
      this.user_teams,
      this.is_notification_subscribed});

  factory MatchDetails.fromJson(Map<String, dynamic> json) =>
      _$MatchDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MatchDetailsToJson(this);
}

@JsonSerializable()
class SportType {
  String? sport_name;
  String? sport_key;
  String? image;

  SportType(this.sport_name, this.sport_key, this.image);

  factory SportType.fromJson(Map<String, dynamic> json) =>
      _$SportTypeFromJson(json);
  Map<String, dynamic> toJson() => _$SportTypeToJson(this);
}

@JsonSerializable()
class LeaderBoardSport {
  String? sport_name;
  String? sport_key;
  String? image;
  int? position;

  LeaderBoardSport(this.sport_name, this.sport_key, this.image, this.position);

  factory LeaderBoardSport.fromJson(Map<String, dynamic> json) =>
      _$LeaderBoardSportFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderBoardSportToJson(this);
}

@JsonSerializable()
class Slots {
  int? id;
  String? type;
  double? min_over;
  double? max_over;
  int? inning;

  Slots({this.id, this.type, this.min_over, this.max_over, this.inning});

  factory Slots.fromJson(Map<String, dynamic> json) => _$SlotsFromJson(json);
  Map<String, dynamic> toJson() => _$SlotsToJson(this);
}

@JsonSerializable()
class Locktime {
  String? date;
  String? timezone;
  int? timezone_type;

  Locktime({this.date, this.timezone, this.timezone_type});

  factory Locktime.fromJson(Map<String, dynamic> json) =>
      _$LocktimeFromJson(json);
  Map<String, dynamic> toJson() => _$LocktimeToJson(this);
}

@JsonSerializable()
class Sport_radious {
  double? radiusX;
  double? radiusY;

  Sport_radious({this.radiusX, this.radiusY});

  factory Sport_radious.fromJson(Map<String, dynamic> json) =>
      _$Sport_radiousFromJson(json);
  Map<String, dynamic> toJson() => _$Sport_radiousToJson(this);
}

@JsonSerializable()
class BannerListResponse {
  int? status;
  int? is_popup_redirect;
  int? version;
  dynamic gst_rebat;
  dynamic gst_deduct;
  dynamic winning_commission;
  int? is_visible_affiliate;
  int? is_visible_promote;
  int? is_visible_promoter_leaderboard;
  int? is_visible_promoter_requested;
  String? message;
  String? popup_link;
  int? version_code;
  String? version_changes;
  String? app_download_url;
  String? refer_url;
  String? base_url;
  String? api_base_url;
  int? popup_status;
  String? popup_image;
  int? poup_time;
  int? show_popup;
  int? notification;
  int? email_verify;
  int? bank_verify;
  int? mobile_verify;
  int? pan_verify;
  int? aadhar_verify;
  String? team;
  String? state;
  String? popup_type;
  String? popup_url;
  String? popup_redirect_type;
  String? is_withdraw;
  String? is_inst_withdraw;
  String? is_promotor_withdraw;
  String? is_promotor_inst_withdraw;
  var popup_series_id;
  var popup_offer_code;
  MatchDetails? match_details;
  List<SportType>? visible_sports;

  List<LeaderBoardSport>? sport_leaderboard;
  Sport_radious? sport_radious;
  List<BannerListItem>? result;
  int? is_series_matches_slides;
  List<Slide>? slide;
  int? gst_bonus;
  int? version_code_playstore;
  int? version_code_ios;
  dynamic is_deposit_leaderbord;
  dynamic is_investment_leaderboard;
  dynamic is_series_leaderboard;
  dynamic max_team_add_limit;
  String? min_deposit;
  String? max_deposit;
  String? min_inst_withdraw;
  String? max_inst_withdraw;
  String? min_withdraw;
  String? max_withdraw;

  String? winning_to_transfer_min;
  String? winning_to_transfer_max;

  String? winning_to_transfer_per_day_limit;
  String? winning_to_deposit_extra_commission;

  String? show_phonepe;
  String? show_nttpay;
  String? show_razorpay;
  String? cashfree;
  int? address_verify_show;
  int? address_verify;
  List<String>? banned_state;
  Map<String, String>? address_doc_type;
  String? show_phonepe_text;
  String? show_nttpay_text;
  String? show_cashfree_text;
  String? refer_bonus_amount;
  String? sign_up_bonus_amount;
  String? show_upi_verification;
  String? private_contest;
  int? max_team_limit;
  int? forced_update;
  int? show_update_popuop;
  int? version_android_ios;
  String? app_store_url;
  int? show_affiliate_wallet;
  int? show_affiliate_wallet_withdraw;

  List<String>? similer_join_contest_list;
  int? is_myaccount_enabled;
  ContactInfo? contact_us;
  int? cashfree_mode;
  ExternalPages? external_pages;
  String? whatsapp_url;
  String? telegram_url;
  String? show_whatsapp_support;
  String? show_telegram_support;
  String? show_refer_earn;
  String? show_refer_list;
  int? total_referal_all;
  String? cart_feature_enable;

  BannerListResponse(
      {this.slide,
      this.is_series_matches_slides,
      this.status,
      this.refer_url,
      this.is_popup_redirect,
      this.version,
      this.is_visible_affiliate,
      this.is_visible_promote,
      this.is_visible_promoter_leaderboard,
      this.is_visible_promoter_requested,
      this.message,
      this.popup_link,
      this.version_code,
      this.version_changes,
      this.app_download_url,
      this.base_url,
      this.api_base_url,
      this.popup_status,
      this.popup_image,
      this.poup_time,
      this.show_popup,
      this.notification,
      this.team,
      this.state,
      this.popup_type,
      this.popup_url,
      this.popup_redirect_type,
      this.is_withdraw,
      this.is_inst_withdraw,
      this.is_promotor_withdraw,
      this.is_promotor_inst_withdraw,
      this.popup_series_id,
      this.popup_offer_code,
      this.match_details,
      this.visible_sports,
      this.sport_leaderboard,
      this.sport_radious,
      this.result,
      this.email_verify,
      this.bank_verify,
      this.mobile_verify,
      this.pan_verify,
      this.aadhar_verify,
      this.gst_deduct,
      this.gst_rebat,
      this.gst_bonus,
      this.version_code_playstore,
      this.winning_commission,
      this.is_deposit_leaderbord,
      this.is_investment_leaderboard,
      this.is_series_leaderboard,
      this.version_code_ios,
      this.max_team_add_limit,
      this.max_deposit,
      this.min_deposit,
      this.min_inst_withdraw,
      this.max_inst_withdraw,
      this.min_withdraw,
      this.max_withdraw,
      this.winning_to_transfer_min,
      this.winning_to_transfer_max,
      this.winning_to_transfer_per_day_limit,
      this.winning_to_deposit_extra_commission,
      this.show_phonepe,
      this.show_nttpay,
      this.show_razorpay,
      this.cashfree,
      this.address_verify_show,
      this.address_verify,
      this.banned_state,
      this.address_doc_type,
      this.show_phonepe_text,
      this.show_nttpay_text,
      this.show_cashfree_text,
      this.refer_bonus_amount,
      this.sign_up_bonus_amount,
      this.show_upi_verification,
      this.private_contest,
      this.max_team_limit,
      this.forced_update,
      this.show_update_popuop,
      this.version_android_ios,
      this.app_store_url,
      this.show_affiliate_wallet,
      this.show_affiliate_wallet_withdraw,
      this.similer_join_contest_list,
      this.is_myaccount_enabled,
      this.contact_us,
      this.cashfree_mode,
      this.external_pages,
      this.whatsapp_url,
      this.show_whatsapp_support,
      this.show_telegram_support,
      this.show_refer_earn,
      this.show_refer_list,
      this.total_referal_all,
      this.cart_feature_enable});

  factory BannerListResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BannerListResponseToJson(this);
}

@JsonSerializable()
class addressDocType {
  String? aadhar;
  String? voter;

  addressDocType({this.aadhar, this.voter});

  factory addressDocType.fromJson(Map<String, dynamic> json) =>
      _$addressDocTypeFromJson(json);
  Map<String, dynamic> toJson() => _$addressDocTypeToJson(this);
}

@JsonSerializable()
class Slide {
  String? series_name;
  int? series_id;
  int? is_leaderboard;
  List<Matches>? matches;

  Slide({this.series_name, this.series_id, this.is_leaderboard, this.matches});

  factory Slide.fromJson(Map<String, dynamic> json) => _$SlideFromJson(json);
  Map<String, dynamic> toJson() => _$SlideToJson(this);
}

@JsonSerializable()
class Matches {
  String? team1display;
  String? team2display;
  String? team1_color_code;
  String? team2_color_code;
  String? start_date;
  String? team1logo;
  String? team2logo;
  String? matchkey;
  dynamic is_giveaway;
  String? giveaway_heading;
  String? giveaway_subheading;

  Matches(
      {this.team1display,
      this.team2display,
      this.team1_color_code,
      this.team2_color_code,
      this.start_date,
      this.team1logo,
      this.team2logo,
      this.matchkey,
      this.is_giveaway,
      this.giveaway_heading,
      this.giveaway_subheading});

  factory Matches.fromJson(Map<String, dynamic> json) =>
      _$MatchesFromJson(json);
  Map<String, dynamic> toJson() => _$MatchesToJson(this);
}

@JsonSerializable()
class ContactInfo {
  String? title;
  String? email_detail;
  String? mobile_detail;
  String? facebook;
  String? twitter;
  String? instagram;
  String? telegram;
  String? youtube;
  String? whatsup;

  ContactInfo({
    this.title,
    this.email_detail,
    this.mobile_detail,
    this.facebook,
    this.twitter,
    this.instagram,
    this.telegram,
    this.youtube,
    this.whatsup,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);
}

@JsonSerializable()
class ExternalPages {
  String? terms;
  String? fantasy_points;
  String? privacy;
  String? about_us;
  String? how_to_play;
  String? legalities;
  String? responsible_play;
  String? fair_play;
  String? refund_policy;
  String? help_desk;

  ExternalPages({
    this.terms,
    this.fantasy_points,
    this.privacy,
    this.about_us,
    this.how_to_play,
    this.legalities,
    this.responsible_play,
    this.fair_play,
    this.refund_policy,
    this.help_desk,
  });

  factory ExternalPages.fromJson(Map<String, dynamic> json) =>
      _$ExternalPagesFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalPagesToJson(this);
}
