// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerInfoMatchesItem _$PlayerInfoMatchesItemFromJson(
        Map<String, dynamic> json) =>
    PlayerInfoMatchesItem(
      json['matchdate'] as String?,
      json['matchname'] as String?,
      json['total_points'],
      json['selectper'] as String?,
      json['short_name'] as String?,
      json['playername'] as String?,
    );

Map<String, dynamic> _$PlayerInfoMatchesItemToJson(
        PlayerInfoMatchesItem instance) =>
    <String, dynamic>{
      'matchdate': instance.matchdate,
      'matchname': instance.matchname,
      'total_points': instance.total_points,
      'selectper': instance.selectper,
      'short_name': instance.short_name,
      'playername': instance.playername,
    };

PlayerInfoResult _$PlayerInfoResultFromJson(Map<String, dynamic> json) =>
    PlayerInfoResult(
      country: json['country'] as String?,
      playerimage: json['playerimage'] as String?,
      teams: json['teams'] as String?,
      battingstyle: json['battingstyle'] as String?,
      total_points: json['total_points'],
      playerpoints: json['playerpoints'],
      playercredit: json['playercredit'],
      per: json['per'],
      playerrole: json['playerrole'] as String?,
      playerkey: json['playerkey'] as String?,
      bowlingstyle: json['bowlingstyle'] as String?,
      dob: json['dob'] as String?,
      playername: json['playername'] as String?,
      matches: (json['matches'] as List<dynamic>?)
          ?.map(
              (e) => PlayerInfoMatchesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      match_played: (json['match_played'] as num?)?.toInt(),
      selected_percent: json['selected_percent'] as String?,
    );

Map<String, dynamic> _$PlayerInfoResultToJson(PlayerInfoResult instance) =>
    <String, dynamic>{
      'country': instance.country,
      'playerimage': instance.playerimage,
      'teams': instance.teams,
      'battingstyle': instance.battingstyle,
      'total_points': instance.total_points,
      'playerpoints': instance.playerpoints,
      'playercredit': instance.playercredit,
      'per': instance.per,
      'playerrole': instance.playerrole,
      'playerkey': instance.playerkey,
      'bowlingstyle': instance.bowlingstyle,
      'dob': instance.dob,
      'playername': instance.playername,
      'match_played': instance.match_played,
      'selected_percent': instance.selected_percent,
      'matches': instance.matches,
    };

PLayerInfoResponse _$PLayerInfoResponseFromJson(Map<String, dynamic> json) =>
    PLayerInfoResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : PlayerInfoResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PLayerInfoResponseToJson(PLayerInfoResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
