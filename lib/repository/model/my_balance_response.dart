import 'package:json_annotation/json_annotation.dart';
part 'my_balance_response.g.dart';

@JsonSerializable()
class MyBalanceResultItem {
  String? total;
  String? balance;
  String? winning;
  String? totalamount;
  int? expireamount;
  int? total_match_play;
  String? bonus;
  int? total_league_play;
  String? total_winning;
  int? total_contest_win;
  int? email_verify;
  int? bank_verify;
  int? mobile_verify;
  int? pan_verify;
  int? aadhar_verify;
  int? upi_verify;
  String? is_withdraw;
  String? is_inst_withdraw;
  String? is_promotor_withdraw;
  String? is_promotor_inst_withdraw;
  String? kyc_deposit_check;
  String? kyc_deposit_limit;
  String? total_cashfree_deposit;
  String? kyc_deposit_msg;
  int? level;
  String? signup_refer_statement;
  String? refer_statement;
  String? Refer_code;
  String? Both_earn;
  String? lifetime_commission;
  String? Both_earn_stmt;
  String? lifetime_commission_stmt;
  String? is_lifetime_commission;
  String? withdraw_limit_string;
  dynamic withdraw_min_limit;
  dynamic withdraw_max_limit;
  String? score_focus;
  String? commentry_focus;
  String? score_card_focus;
  String? gst_bonus;
  String? refer_affiliate;
  int? kyc_verified;
  dynamic affiliate_commission;
  bool? for_play_store;
  String? transfer_benifit;
  String? transfer_benifit_text;
  String? transfer_text;
  String? transfer_text1;
  String? transfer_text2;
  String? transfer_text3;
  String? transfer_benifit_percent;
  String? show_admin_upi;
  List<UPIList>? admin_upi_list;
  String? show_admin_bank;
  String? admin_bank_name;
  String? admin_bank_ifsc;
  String? admin_bank_customer_name;
  String? admin_bank_account;
  String? show_web_payment;

  MyBalanceResultItem(
      {this.total,
      this.balance,
      this.winning,
      this.totalamount,
      this.expireamount,
      this.total_match_play,
      this.bonus,
      this.total_league_play,
      this.total_winning,
      this.total_contest_win,
      this.email_verify,
      this.bank_verify,
      this.mobile_verify,
      this.pan_verify,
      this.aadhar_verify,
      this.upi_verify,
      this.is_withdraw,
      this.is_inst_withdraw,
      this.is_promotor_withdraw,
      this.is_promotor_inst_withdraw,
      this.kyc_deposit_check,
      this.kyc_deposit_limit,
      this.total_cashfree_deposit,
      this.kyc_deposit_msg,
      this.level,
      this.Both_earn,
      this.Refer_code,
      this.refer_statement,
      this.signup_refer_statement,
      this.lifetime_commission,
      this.Both_earn_stmt,
      this.is_lifetime_commission,
      this.lifetime_commission_stmt,
      this.withdraw_limit_string,
      this.withdraw_min_limit,
      this.withdraw_max_limit,
      this.commentry_focus,
      this.score_card_focus,
      this.score_focus,
      this.kyc_verified,
      this.for_play_store,
      this.gst_bonus,
      this.affiliate_commission,
      this.refer_affiliate,
      this.transfer_benifit,
      this.transfer_benifit_text,
      this.transfer_text,
      this.transfer_text1,
      this.transfer_text2,
      this.transfer_text3,
      this.transfer_benifit_percent,
      this.show_admin_upi,
      this.admin_upi_list,
      this.show_admin_bank,
      this.admin_bank_name,
      this.admin_bank_ifsc,
      this.admin_bank_customer_name,
      this.admin_bank_account,this.show_web_payment});

  factory MyBalanceResultItem.fromJson(Map<String, dynamic> json) =>
      _$MyBalanceResultItemFromJson(json);
  Map<String, dynamic> toJson() => _$MyBalanceResultItemToJson(this);
}

@JsonSerializable()
class MyBalanceResponse {
  int? status;
  String? message;
  List<MyBalanceResultItem>? result;

  MyBalanceResponse({this.status, this.message, this.result});

  factory MyBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$MyBalanceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MyBalanceResponseToJson(this);
}

@JsonSerializable()
class UPIList {
  int? id;
  String? upi_name;
  String? upi_number;
  String? Text;
  String? scanner_image;

  UPIList(
      {this.id, this.upi_name, this.upi_number, this.Text, this.scanner_image});

  factory UPIList.fromJson(Map<String, dynamic> json) =>
      _$UPIListFromJson(json);
  Map<String, dynamic> toJson() => _$UPIListToJson(this);
}
