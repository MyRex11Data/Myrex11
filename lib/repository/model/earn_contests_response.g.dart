// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earn_contests_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EarnContestItem _$EarnContestItemFromJson(Map<String, dynamic> json) =>
    EarnContestItem(
      win_amount: (json['win_amount'] as num?)?.toInt(),
      maximum_user: (json['maximum_user'] as num?)?.toInt(),
      entryfee: (json['entryfee'] as num?)?.toInt(),
      joined: (json['joined'] as num?)?.toInt(),
      bonus_used: json['bonus_used'],
      earned: json['earned'] as String?,
      challenge_id: json['challenge_id'],
    );

Map<String, dynamic> _$EarnContestItemToJson(EarnContestItem instance) =>
    <String, dynamic>{
      'win_amount': instance.win_amount,
      'maximum_user': instance.maximum_user,
      'entryfee': instance.entryfee,
      'joined': instance.joined,
      'bonus_used': instance.bonus_used,
      'earned': instance.earned,
      'challenge_id': instance.challenge_id,
    };

EarnContestTotal _$EarnContestTotalFromJson(Map<String, dynamic> json) =>
    EarnContestTotal(
      joined: json['joined'],
      total_contest: json['total_contest'],
      earned: json['earned'],
    );

Map<String, dynamic> _$EarnContestTotalToJson(EarnContestTotal instance) =>
    <String, dynamic>{
      'joined': instance.joined,
      'total_contest': instance.total_contest,
      'earned': instance.earned,
    };

EarnContestResult _$EarnContestResultFromJson(Map<String, dynamic> json) =>
    EarnContestResult(
      total: json['total'] == null
          ? null
          : EarnContestTotal.fromJson(json['total'] as Map<String, dynamic>),
      contests: (json['contests'] as List<dynamic>?)
          ?.map((e) => EarnContestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EarnContestResultToJson(EarnContestResult instance) =>
    <String, dynamic>{
      'total': instance.total,
      'contests': instance.contests,
    };

EarnContestResponse _$EarnContestResponseFromJson(Map<String, dynamic> json) =>
    EarnContestResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : EarnContestResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EarnContestResponseToJson(
        EarnContestResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
