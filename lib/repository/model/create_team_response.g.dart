// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_team_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamResult _$TeamResultFromJson(Map<String, dynamic> json) => TeamResult(
      marathonstatus: (json['marathonstatus'] as num?)?.toInt(),
      teamid: (json['teamid'] as num?)?.toInt(),
      teamcount: (json['teamcount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TeamResultToJson(TeamResult instance) =>
    <String, dynamic>{
      'marathonstatus': instance.marathonstatus,
      'teamid': instance.teamid,
      'teamcount': instance.teamcount,
      'status': instance.status,
    };

CreateTeamResponse _$CreateTeamResponseFromJson(Map<String, dynamic> json) =>
    CreateTeamResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : TeamResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateTeamResponseToJson(CreateTeamResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
