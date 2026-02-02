// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestData _$ContestDataFromJson(Map<String, dynamic> json) => ContestData(
      user_teams: (json['user_teams'] as num?)?.toInt(),
      joined_leagues: (json['joined_leagues'] as num?)?.toInt(),
      contest: (json['contest'] as List<dynamic>?)
          ?.map((e) => Contest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContestDataToJson(ContestData instance) =>
    <String, dynamic>{
      'user_teams': instance.user_teams,
      'joined_leagues': instance.joined_leagues,
      'contest': instance.contest,
    };

ContestResponse _$ContestResponseFromJson(Map<String, dynamic> json) =>
    ContestResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : ContestData.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContestResponseToJson(ContestResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
