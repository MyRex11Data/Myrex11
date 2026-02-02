import 'package:flutter/cupertino.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';

class JoinChallengeDataModel {
  BuildContext context;
  int newChallengeId;
  int userId;
  int ChallengeId;
  int selectedFantasyType;
  /*int selectedSlotId;*/
  int totalSelected;
  int isBonus;
  int winningAmount;
  int maxUser;
  String teamId;
  String entryFee;
  String matchKey;
  String sport_key;
  String isJoinId;
  bool isSwitchTeam;
  double availableB;
  double usableB;
  dynamic is_gstbonus;
  Function onJoinContestResult;
  dynamic bonusPercentage;
  int? is_free_for_referrer;
  dynamic? discount_amount;
  dynamic? total_entry_fee;
  dynamic? to_pay_amount;
  int? total_team;
  String? total_entry_fee_text;
  String? total_team_text;
  String? discount_amount_text;
  int? is_bonus;
  String? Usable_cash_bonus_stmt;
  String? Usable_cash_bonus_amount;
  String? uti_balance_stmt;
  String? entry_fee_stmt;
  String? to_pay_stmt;
  String? terms_text;
  Contest contest;
  Function? leaderboardApi;
  String? multiple_contest;

  JoinChallengeDataModel(
      this.context,
      this.newChallengeId,
      this.userId,
      this.ChallengeId,
      this.selectedFantasyType,
      /*this.selectedSlotId,*/
      this.totalSelected,
      this.isBonus,
      this.winningAmount,
      this.maxUser,
      this.teamId,
      this.entryFee,
      this.matchKey,
      this.sport_key,
      this.isJoinId,
      this.isSwitchTeam,
      this.availableB,
      this.usableB,
      this.onJoinContestResult,
      this.contest,
      {this.bonusPercentage,
      this.is_free_for_referrer,
      this.discount_amount,
      this.total_entry_fee,
      this.to_pay_amount,
      this.total_team,
      this.total_entry_fee_text,
      this.total_team_text,
      this.discount_amount_text,
      this.is_bonus,
      this.Usable_cash_bonus_stmt,
      this.Usable_cash_bonus_amount,
      this.uti_balance_stmt,
      this.entry_fee_stmt,
      this.to_pay_stmt,
      this.terms_text,
      this.leaderboardApi,
      this.multiple_contest});
}
