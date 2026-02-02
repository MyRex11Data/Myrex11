import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'base_request.g.dart';

@JsonSerializable()
class GeneralRequest {
  late String? user_id;
  late String? mobile;
  late String? type;
  late String? file;
  late String? amount;
  late String? email;
  late String? email_or_mobile;
  late String? matchkey;
  late String? promo;
  late String? payment_type;
  late String? ip;
  late String? challenge_id;
  late String? sport_key;
  late String? team1_id;
  late String? team2_id;
  late String? series_id;
  late String? verification_type;
  late String? start_date;
  late String? end_date;
  late String? page;
  late String? my_fav_contest;
  late String? fantasy_type;
  late String? slotes_id;
  late String? promoter_leaderboard_id;
  late String? fcmToken;
  late String? search;
  late String? oldpassword;
  late String? newpassword;
  late String? otp;
  late String? playerid;
  late String? is_fav_pin_contest;
  late String? product_name;
  late String? product_type;
  late String? currency;
  late String? order_id;
  late String? store_id;
  late String? device_type;
  late String? pay_type;
  String? gstAmount;
  String? fantasy_type_id;
  String? affiliate_commission;
  dynamic referral;
  String? buildType;
  String? myIp;
  String? androidId;
  String? from_user_id;
  String? deposit_id;
  int? is_skiped_update;
  int? is_skiped_popup;
  int? is_playstore_build;
  String? teamid;

  GeneralRequest(
      {this.deposit_id,
      this.gstAmount,
      this.user_id,
      this.mobile,
      this.type,
      this.file,
      this.amount,
      this.email,
      this.email_or_mobile,
      this.matchkey,
      this.promo,
      this.payment_type,
      this.ip,
      this.challenge_id,
      this.sport_key,
      this.team1_id,
      this.team2_id,
      this.series_id,
      this.verification_type,
      this.start_date,
      this.end_date,
      this.page,
      this.my_fav_contest,
      this.fantasy_type,
      this.slotes_id,
      this.promoter_leaderboard_id,
      this.fcmToken,
      this.search,
      this.oldpassword,
      this.newpassword,
      this.otp,
      this.playerid,
      this.is_fav_pin_contest,
      this.store_id,
      this.order_id,
      this.currency,
      this.product_type,
      this.product_name,
      this.device_type,
      this.pay_type,
      this.affiliate_commission,
      this.fantasy_type_id,
      this.referral,
      this.buildType,
      this.myIp,
      this.androidId,
      this.from_user_id,
      this.is_skiped_update,
      this.is_skiped_popup,
      this.is_playstore_build,
      this.teamid});

  Map<String, dynamic> toJson() => _$GeneralRequestToJson(this);
}

@JsonSerializable()
class NormalRequest {
  String? user_id;
  String? payment_type;
  late String? amount;
  String? affiliate_commission;
  String? build_type;

  NormalRequest(
      {this.user_id,
      this.amount,
      this.payment_type,
      this.affiliate_commission,
      this.build_type});

  factory NormalRequest.fromJson(Map<String, dynamic> json) =>
      _$NormalRequestFromJson(json);
  Map<String, dynamic> toJson() => _$NormalRequestToJson(this);
}

@JsonSerializable()
class BankInstantRequest {
  String? user_id;
  String? withdraw_request_id;
  String? status;

  BankInstantRequest({this.user_id, this.withdraw_request_id, this.status});

  factory BankInstantRequest.fromJson(Map<String, dynamic> json) =>
      _$BankInstantRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BankInstantRequestToJson(this);
}
