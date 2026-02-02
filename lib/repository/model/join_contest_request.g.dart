// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_contest_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinContestRequest _$JoinContestRequestFromJson(Map<String, dynamic> json) =>
    JoinContestRequest(
      matchkey: json['matchkey'] as String?,
      user_id: json['user_id'] as String?,
      challengeid: json['challengeid'] as String?,
      sport_key: json['sport_key'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
      teamid: json['teamid'] as String?,
      multiple_contest: json['multiple_contest'] as String?,
      fantasy_type_id: json['fantasy_type_id'] as String?,
      join_similar_count: json['join_similar_count'] as String?,
    );

Map<String, dynamic> _$JoinContestRequestToJson(JoinContestRequest instance) =>
    <String, dynamic>{
      'matchkey': instance.matchkey,
      'user_id': instance.user_id,
      'challengeid': instance.challengeid,
      'sport_key': instance.sport_key,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
      'teamid': instance.teamid,
      'multiple_contest': instance.multiple_contest,
      'fantasy_type_id': instance.fantasy_type_id,
      'join_similar_count': instance.join_similar_count,
    };
