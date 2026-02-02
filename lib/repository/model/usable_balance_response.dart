import 'package:json_annotation/json_annotation.dart';
part 'usable_balance_response.g.dart';

@JsonSerializable()
class UsableBalanceItem {
  var usablebalance;
  var usertotalbalance;
  double? marathon;
  int? is_bonus;
  int? is_free_for_referrer;
  dynamic entry_fees;
  dynamic to_pay;
  dynamic is_gstbonus;
  dynamic discount_amount;
  dynamic total_entry_fee;
  dynamic to_pay_amount;
  int? total_team;
  String? entry_fee_real_balance;
  String? Usable_cash_bonus_stmt;
  String? Usable_cash_bonus_amount;
  String? to_pay_stmt;
  String? terms_text;
  String? total_team_text;
  String? total_entry_fee_text;
  String? discount_amount_text;
  String? uti_balance_stmt;
  String? entry_fee_stmt;
  String? wallet_bonus;
  String? wallet_gstbonus;

  UsableBalanceItem(
      {this.usablebalance,
      this.usertotalbalance,
      this.marathon,
      this.is_bonus,
      this.is_free_for_referrer,
      this.is_gstbonus,
      this.discount_amount,
      this.total_entry_fee,
      this.to_pay_amount,
      this.total_team,
      this.entry_fees,
      this.to_pay,
      this.entry_fee_real_balance,
      this.entry_fee_stmt,
      this.Usable_cash_bonus_stmt,
      this.Usable_cash_bonus_amount,
      this.to_pay_stmt,
      this.terms_text,
      this.uti_balance_stmt,
      this.total_entry_fee_text,
      this.total_team_text,
      this.discount_amount_text,
      this.wallet_bonus,
      this.wallet_gstbonus});

  factory UsableBalanceItem.fromJson(Map<String, dynamic> json) =>
      _$UsableBalanceItemFromJson(json);
  Map<String, dynamic> toJson() => _$UsableBalanceItemToJson(this);
}

@JsonSerializable()
class BalanceResponse {
  int? status;
  String? message;
  List<UsableBalanceItem>? result;
  int? new_challenge_id;

  BalanceResponse(
      {this.status, this.message, this.result, this.new_challenge_id});

  factory BalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$BalanceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceResponseToJson(this);
}
