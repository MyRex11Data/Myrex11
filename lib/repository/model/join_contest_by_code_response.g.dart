// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_contest_by_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinContestByCodeItem _$JoinContestByCodeItemFromJson(
        Map<String, dynamic> json) =>
    JoinContestByCodeItem(
      message: json['message'] as String?,
      contest: json['contest'] == null
          ? null
          : Contest.fromJson(json['contest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JoinContestByCodeItemToJson(
        JoinContestByCodeItem instance) =>
    <String, dynamic>{
      'message': instance.message,
      'contest': instance.contest,
    };

JoinContestByCodeResponse _$JoinContestByCodeResponseFromJson(
        Map<String, dynamic> json) =>
    JoinContestByCodeResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map(
              (e) => JoinContestByCodeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JoinContestByCodeResponseToJson(
        JoinContestByCodeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
