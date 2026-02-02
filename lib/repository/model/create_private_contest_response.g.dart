// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_private_contest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateContestItemResponse _$PrivateContestItemResponseFromJson(
        Map<String, dynamic> json) =>
    PrivateContestItemResponse(
      challengeid: (json['challengeid'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      contest: json['contest'] == null
          ? null
          : Contest.fromJson(json['contest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivateContestItemResponseToJson(
        PrivateContestItemResponse instance) =>
    <String, dynamic>{
      'challengeid': instance.challengeid,
      'status': instance.status,
      'contest': instance.contest,
    };

CreatePrivateContestResponse _$CreatePrivateContestResponseFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateContestResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) =>
              PrivateContestItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreatePrivateContestResponseToJson(
        CreatePrivateContestResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
