// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_team_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTeamRequest _$CreateTeamRequestFromJson(Map<String, dynamic> json) =>
    CreateTeamRequest(
      matchkey: json['matchkey'] as String?,
      userid: json['userid'] as String?,
      players: json['players'] as String?,
      vicecaptain: json['vicecaptain'] as String?,
      captain: json['captain'] as String?,
      sport_key: json['sport_key'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
      teamid: (json['teamid'] as num?)?.toInt(),
      fantasy_type_id: json['fantasy_type_id'] as String?,
    );

Map<String, dynamic> _$CreateTeamRequestToJson(CreateTeamRequest instance) =>
    <String, dynamic>{
      'matchkey': instance.matchkey,
      'userid': instance.userid,
      'players': instance.players,
      'vicecaptain': instance.vicecaptain,
      'captain': instance.captain,
      'sport_key': instance.sport_key,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
      'fantasy_type_id': instance.fantasy_type_id,
      'teamid': instance.teamid,
    };
