// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestRequest _$ContestRequestFromJson(Map<String, dynamic> json) =>
    ContestRequest(
      credittype: (json['credittype'] as num?)?.toInt(),
      matchkey: json['matchkey'] as String?,
      user_id: json['user_id'] as String?,
      userid: json['userid'] as String?,
      challenge_id: json['challenge_id'] as String?,
      page: json['page'] as String?,
      category_id: json['category_id'] as String?,
      entryfee: json['entryfee'] as String?,
      winning: json['winning'] as String?,
      contest_type: json['contest_type'] as String?,
      contest_size: json['contest_size'] as String?,
      sport_key: json['sport_key'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
      teamid: json['teamid'] as String?,
      joinid: json['joinid'] as String?,
      fantasy_type_id: json['fantasy_type_id'] as String?,
      spots: json['spots'] as String?,
      isEdit: (json['isEdit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContestRequestToJson(ContestRequest instance) =>
    <String, dynamic>{
      'matchkey': instance.matchkey,
      'user_id': instance.user_id,
      'userid': instance.userid,
      'challenge_id': instance.challenge_id,
      'page': instance.page,
      'category_id': instance.category_id,
      'entryfee': instance.entryfee,
      'winning': instance.winning,
      'contest_type': instance.contest_type,
      'contest_size': instance.contest_size,
      'sport_key': instance.sport_key,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
      'teamid': instance.teamid,
      'joinid': instance.joinid,
      'fantasy_type_id': instance.fantasy_type_id,
      'credittype': instance.credittype,
      'spots': instance.spots,
      'isEdit': instance.isEdit,
    };
