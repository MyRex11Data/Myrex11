import 'package:json_annotation/json_annotation.dart';
part 'gst_details_response.g.dart';

@JsonSerializable()
class GstResponse {
  int? status;
  String? message;
  GstDetailsResponseItem? result;

  GstResponse({this.status, this.message, this.result});

  factory GstResponse.fromJson(Map<String, dynamic> json) =>
      _$GstResponseFromJson(json);
  Map<String?, dynamic> toJson() => _$GstResponseToJson(this);
}

@JsonSerializable()
class GstDetailsResponseItem {
  String? offer_text;
  String? gst_saving;
  String? deposit_amount_text;
  String? deposit_amount;
  String? gst_applicable_text;
  double? gst_applicable;
  String? gst_applicable_smalltext;
  double? real_money_bonus;
  String? real_money_bonus_text;
  String? real_money_bonus_smalltext;
  String? total_amount_text;
  double? total_amount;
  String? pay;
  int? is_gst_rebate;

  GstDetailsResponseItem({
    this.offer_text,
    this.gst_saving,
    this.deposit_amount_text,
    this.deposit_amount,
    this.gst_applicable_text,
    this.gst_applicable,
    this.gst_applicable_smalltext,
    this.real_money_bonus,
    this.real_money_bonus_text,
    this.real_money_bonus_smalltext,
    this.total_amount_text,
    this.total_amount,
    this.pay,
    this.is_gst_rebate,
  });

  factory GstDetailsResponseItem.fromJson(Map<String, dynamic> json) =>
      _$GstDetailsResponseItemFromJson(json);
  Map<String?, dynamic> toJson() => _$GstDetailsResponseItemToJson(this);
}

@JsonSerializable()
class WithdrawalConfirmation {
  int? status;
  TDSResultPopUp? result;
  String? message;

  WithdrawalConfirmation({this.status, this.result, this.message});

  factory WithdrawalConfirmation.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalConfirmationFromJson(json);
  Map<String?, dynamic> toJson() => _$WithdrawalConfirmationToJson(this);
}

@JsonSerializable()
class TDSResultPopUp {
  String? heading;
  String? text;
  String? withdrawal_amt_text;
  String? withdrawal_amt;
  String? tds_save_text;
  String? tds_amt;
  String? is_instant;
  String? instant_text;
  String? instant_charges;
  String? tds_text;
  String? tds_charges;
  String? tds_rebate_text;
  String? tds_rebate;
  String? tds_rebate_small_text;
  String? total_amt_text;
  String? total_amt;
  String? is_tds_rebate;

  TDSResultPopUp(
      {this.heading,
      this.text,
      this.withdrawal_amt_text,
      this.withdrawal_amt,
      this.tds_save_text,
      this.tds_amt,
      this.is_instant,
      this.instant_text,
      this.instant_charges,
      this.tds_text,
      this.tds_charges,
      this.tds_rebate_text,
      this.tds_rebate,
      this.tds_rebate_small_text,
      this.total_amt_text,
      this.total_amt,
      this.is_tds_rebate});

  factory TDSResultPopUp.fromJson(Map<String, dynamic> json) =>
      _$TDSResultPopUpFromJson(json);
  Map<String?, dynamic> toJson() => _$TDSResultPopUpToJson(this);
}
