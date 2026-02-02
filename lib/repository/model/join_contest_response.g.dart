// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_contest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinItem _$JoinItemFromJson(Map<String, dynamic> json) => JoinItem(
      status: json['status'] as bool?,
      join_message: json['join_message'] as String?,
      refercode: json['refercode'] as String?,
      isjoined: (json['isjoined'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JoinItemToJson(JoinItem instance) => <String, dynamic>{
      'status': instance.status,
      'join_message': instance.join_message,
      'refercode': instance.refercode,
      'isjoined': instance.isjoined,
    };

JoinContestResponse _$JoinContestResponseFromJson(Map<String, dynamic> json) =>
    JoinContestResponse(
      status: (json['status'] as num?)?.toInt(),
      new_challenge_id: (json['new_challenge_id'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => JoinItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JoinContestResponseToJson(
        JoinContestResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'new_challenge_id': instance.new_challenge_id,
      'message': instance.message,
      'result': instance.result,
    };
