// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelData _$LevelDataFromJson(Map<String, dynamic> json) => LevelData(
      type: json['type'] as String?,
      progress_text: json['progress_text'] as String?,
      progressbar: (json['progressbar'] as num?)?.toDouble(),
      cash_progressbar: (json['cash_progressbar'] as num?)?.toDouble(),
      contest_progressbar: (json['contest_progressbar'] as num?)?.toDouble(),
      currentlevel: (json['currentlevel'] as num?)?.toInt(),
      nextlevel: (json['nextlevel'] as num?)?.toInt(),
      contest: json['contest'],
      is_visible_contest_text:
          (json['is_visible_contest_text'] as num?)?.toInt(),
      is_visible_cash_text: (json['is_visible_cash_text'] as num?)?.toInt(),
      currentlevel_cash: (json['currentlevel_cash'] as num?)?.toInt(),
      nextlevel_cash: json['nextlevel_cash'],
      nextlevel_reward_cash: (json['nextlevel_reward_cash'] as num?)?.toInt(),
      currentlevel_reward_cash:
          (json['currentlevel_reward_cash'] as num?)?.toInt(),
      playing_history: json['playing_history'] == null
          ? null
          : PlayingHistoryModel.fromJson(
              json['playing_history'] as Map<String, dynamic>),
      balance_history: json['balance_history'] == null
          ? null
          : BalanceHistoryModel.fromJson(
              json['balance_history'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LevelDataToJson(LevelData instance) => <String, dynamic>{
      'type': instance.type,
      'progress_text': instance.progress_text,
      'progressbar': instance.progressbar,
      'cash_progressbar': instance.cash_progressbar,
      'contest_progressbar': instance.contest_progressbar,
      'currentlevel': instance.currentlevel,
      'nextlevel': instance.nextlevel,
      'contest': instance.contest,
      'is_visible_contest_text': instance.is_visible_contest_text,
      'is_visible_cash_text': instance.is_visible_cash_text,
      'currentlevel_cash': instance.currentlevel_cash,
      'nextlevel_cash': instance.nextlevel_cash,
      'nextlevel_reward_cash': instance.nextlevel_reward_cash,
      'currentlevel_reward_cash': instance.currentlevel_reward_cash,
      'playing_history': instance.playing_history,
      'balance_history': instance.balance_history,
    };

BalanceHistoryModel _$BalanceHistoryModelFromJson(Map<String, dynamic> json) =>
    BalanceHistoryModel(
      total_winning: json['total_winning'] as String?,
      balance: json['balance'] as String?,
      winning: json['winning'] as String?,
      bonus: json['bonus'] as String?,
      total: json['total'] as String?,
      totalamount: json['totalamount'] as String?,
      expireamount: (json['expireamount'] as num?)?.toInt(),
      total_match_play: (json['total_match_play'] as num?)?.toInt(),
      total_league_play: (json['total_league_play'] as num?)?.toInt(),
      total_contest_win: (json['total_contest_win'] as num?)?.toInt(),
      email_verify: (json['email_verify'] as num?)?.toInt(),
      bank_verify: (json['bank_verify'] as num?)?.toInt(),
      mobile_verify: (json['mobile_verify'] as num?)?.toInt(),
      pan_verify: (json['pan_verify'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BalanceHistoryModelToJson(
        BalanceHistoryModel instance) =>
    <String, dynamic>{
      'total_winning': instance.total_winning,
      'balance': instance.balance,
      'winning': instance.winning,
      'bonus': instance.bonus,
      'total': instance.total,
      'totalamount': instance.totalamount,
      'expireamount': instance.expireamount,
      'total_match_play': instance.total_match_play,
      'total_league_play': instance.total_league_play,
      'total_contest_win': instance.total_contest_win,
      'email_verify': instance.email_verify,
      'bank_verify': instance.bank_verify,
      'mobile_verify': instance.mobile_verify,
      'pan_verify': instance.pan_verify,
    };

PlayingHistoryModel _$PlayingHistoryModelFromJson(Map<String, dynamic> json) =>
    PlayingHistoryModel(
      total_winning: json['total_winning'] as String?,
      total_contest_win: (json['total_contest_win'] as num?)?.toInt(),
      total_league_play: (json['total_league_play'] as num?)?.toInt(),
      total_match_play: (json['total_match_play'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayingHistoryModelToJson(
        PlayingHistoryModel instance) =>
    <String, dynamic>{
      'total_winning': instance.total_winning,
      'total_contest_win': instance.total_contest_win,
      'total_league_play': instance.total_league_play,
      'total_match_play': instance.total_match_play,
    };

LevelDataResponse _$LevelDataResponseFromJson(Map<String, dynamic> json) =>
    LevelDataResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : LevelData.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LevelDataResponseToJson(LevelDataResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
