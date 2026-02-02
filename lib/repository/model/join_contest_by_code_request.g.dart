// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_contest_by_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinContestByCodeRequest _$JoinContestByCodeRequestFromJson(
        Map<String, dynamic> json) =>
    JoinContestByCodeRequest(
      user_id: json['user_id'] as String?,
      matchkey: json['matchkey'] as String?,
      getcode: json['getcode'] as String?,
      sport_key: json['sport_key'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
    );

Map<String, dynamic> _$JoinContestByCodeRequestToJson(
        JoinContestByCodeRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'matchkey': instance.matchkey,
      'getcode': instance.getcode,
      'sport_key': instance.sport_key,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
    };
