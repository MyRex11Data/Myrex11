// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_play_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayData _$PlayDataFromJson(Map<String, dynamic> json) => PlayData(
      total_contest_win: (json['total_contest_win'] as num?)?.toInt(),
      total_league_play: (json['total_league_play'] as num?)?.toInt(),
      total_match_play: (json['total_match_play'] as num?)?.toInt(),
      total_winning: json['total_winning'] as String?,
    );

Map<String, dynamic> _$PlayDataToJson(PlayData instance) => <String, dynamic>{
      'total_match_play': instance.total_match_play,
      'total_league_play': instance.total_league_play,
      'total_contest_win': instance.total_contest_win,
      'total_winning': instance.total_winning,
    };

PlayDataResponse _$PlayDataResponseFromJson(Map<String, dynamic> json) =>
    PlayDataResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : PlayData.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayDataResponseToJson(PlayDataResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
