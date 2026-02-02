// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchListResponse _$MatchListResponseFromJson(Map<String, dynamic> json) =>
    MatchListResponse(
      status: (json['status'] as num?)?.toInt(),
      total_page: (json['total_page'] as num?)?.toInt(),
      total_live_match: (json['total_live_match'] as num?)?.toInt(),
      message: json['message'] as String?,
      result_series: json['result_series'] == null
          ? null
          : SeriesListResponse.fromJson(
              json['result_series'] as Map<String, dynamic>),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => MatchDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      users_matches: (json['users_matches'] as List<dynamic>?)
          ?.map((e) => MatchDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MatchListResponseToJson(MatchListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total_page': instance.total_page,
      'total_live_match': instance.total_live_match,
      'message': instance.message,
      'result_series': instance.result_series,
      'result': instance.result,
      'users_matches': instance.users_matches,
    };

SeriesListResponse _$SeriesListResponseFromJson(Map<String, dynamic> json) =>
    SeriesListResponse(
      id: (json['id'] as num?)?.toInt(),
      is_series_leaderboard: (json['is_series_leaderboard'] as num?)?.toInt(),
      name: json['name'] as String?,
      matches: (json['matches'] as List<dynamic>?)
          ?.map((e) => MatchDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeriesListResponseToJson(SeriesListResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_series_leaderboard': instance.is_series_leaderboard,
      'name': instance.name,
      'matches': instance.matches,
    };
