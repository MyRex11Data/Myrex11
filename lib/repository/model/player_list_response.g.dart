// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Limit _$LimitFromJson(Map<String, dynamic> json) => Limit(
      maxplayers: (json['maxplayers'] as num?)?.toInt(),
      team_max_player: (json['team_max_player'] as num?)?.toInt(),
      total_credits: (json['total_credits'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LimitToJson(Limit instance) => <String, dynamic>{
      'maxplayers': instance.maxplayers,
      'team_max_player': instance.team_max_player,
      'total_credits': instance.total_credits,
    };

PlayerListResponse _$PlayerListResponseFromJson(Map<String, dynamic> json) =>
    PlayerListResponse(
      is_visible_lineup: (json['is_visible_lineup'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      is_lineup_out: (json['is_lineup_out'] as num?)?.toInt(),
      is_visible_uploadscreenshot:
          (json['is_visible_uploadscreenshot'] as num?)?.toInt(),
      message: json['message'] as String?,
      lineup_text: json['lineup_text'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      limit: json['limit'] == null
          ? null
          : Limit.fromJson(json['limit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerListResponseToJson(PlayerListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'is_visible_lineup': instance.is_visible_lineup,
      'is_lineup_out': instance.is_lineup_out,
      'is_visible_uploadscreenshot': instance.is_visible_uploadscreenshot,
      'message': instance.message,
      'lineup_text': instance.lineup_text,
      'result': instance.result,
      'limit': instance.limit,
    };
