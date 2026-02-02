// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_preview_point_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPreviewPointRequest _$TeamPreviewPointRequestFromJson(
        Map<String, dynamic> json) =>
    TeamPreviewPointRequest(
      user_id: json['user_id'] as String?,
      teamid: json['teamid'] as String?,
      challenge: json['challenge'] as String?,
      sport_key: json['sport_key'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
      fantasy_type_id: json['fantasy_type_id'] as String?,
    );

Map<String, dynamic> _$TeamPreviewPointRequestToJson(
        TeamPreviewPointRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'teamid': instance.teamid,
      'challenge': instance.challenge,
      'sport_key': instance.sport_key,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
      'fantasy_type_id': instance.fantasy_type_id,
    };
