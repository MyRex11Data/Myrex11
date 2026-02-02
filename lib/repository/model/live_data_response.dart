import 'package:json_annotation/json_annotation.dart';
part 'live_data_response.g.dart';

@JsonSerializable()
class LevelData{
  String? type;
  String? progress_text;
  double? progressbar;
  double? cash_progressbar;
  double? contest_progressbar;
  int? currentlevel;
  int? nextlevel;
  var contest;
  int? is_visible_contest_text;
  int? is_visible_cash_text;
  int? currentlevel_cash;
  var nextlevel_cash;
  int? nextlevel_reward_cash;
  int? currentlevel_reward_cash;
  PlayingHistoryModel? playing_history;
  BalanceHistoryModel? balance_history;


  LevelData({
      this.type,
      this.progress_text,
      this.progressbar,
      this.cash_progressbar,
      this.contest_progressbar,
      this.currentlevel,
      this.nextlevel,
      this.contest,
      this.is_visible_contest_text,
      this.is_visible_cash_text,
      this.currentlevel_cash,
      this.nextlevel_cash,
      this.nextlevel_reward_cash,
      this.currentlevel_reward_cash,
      this.playing_history,
      this.balance_history});

  factory LevelData.fromJson(Map<String, dynamic> json) => _$LevelDataFromJson(json);
  Map<String, dynamic> toJson() => _$LevelDataToJson(this);
}

@JsonSerializable()
class BalanceHistoryModel{
  String? total_winning;
  String? balance;
  String? winning;
  String? bonus;
  String? total;
  String? totalamount;
  int? expireamount;
  int? total_match_play;
  int? total_league_play;
  int? total_contest_win;
  int? email_verify;
  int? bank_verify;
  int? mobile_verify;
  int? pan_verify;


  BalanceHistoryModel({
      this.total_winning,
      this.balance,
      this.winning,
      this.bonus,
      this.total,
      this.totalamount,
      this.expireamount,
      this.total_match_play,
      this.total_league_play,
      this.total_contest_win,
      this.email_verify,
      this.bank_verify,
      this.mobile_verify,
      this.pan_verify});

  factory BalanceHistoryModel.fromJson(Map<String, dynamic> json) => _$BalanceHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$BalanceHistoryModelToJson(this);
}


@JsonSerializable()
class PlayingHistoryModel{
  String? total_winning;
  int? total_contest_win;
  int? total_league_play;
  int? total_match_play;


  PlayingHistoryModel({this.total_winning, this.total_contest_win,
      this.total_league_play, this.total_match_play});

  factory PlayingHistoryModel.fromJson(Map<String, dynamic> json) => _$PlayingHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayingHistoryModelToJson(this);
}

@JsonSerializable()
class LevelDataResponse{
  int? status;
  String? message;
  LevelData? result;


  LevelDataResponse({this.status, this.message,
      this.result}); // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory LevelDataResponse.fromJson(Map<String, dynamic> json) => _$LevelDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LevelDataResponseToJson(this);

}