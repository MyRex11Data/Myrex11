// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finish_matchlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishMatchResult _$FinishMatchResultFromJson(Map<String, dynamic> json) =>
    FinishMatchResult(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MatchDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      current_page: (json['current_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      per_page: (json['per_page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FinishMatchResultToJson(FinishMatchResult instance) =>
    <String, dynamic>{
      'data': instance.data,
      'current_page': instance.current_page,
      'total': instance.total,
      'per_page': instance.per_page,
    };

FinishMatchListResponse _$FinishMatchListResponseFromJson(
        Map<String, dynamic> json) =>
    FinishMatchListResponse(
      status: (json['status'] as num?)?.toInt(),
      total_live_match: (json['total_live_match'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : FinishMatchResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FinishMatchListResponseToJson(
        FinishMatchListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total_live_match': instance.total_live_match,
      'message': instance.message,
      'result': instance.result,
    };
