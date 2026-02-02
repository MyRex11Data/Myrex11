// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_series_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesItem _$SeriesItemFromJson(Map<String, dynamic> json) => SeriesItem(
      id: (json['id'] as num?)?.toInt(),
      is_leaderboard: (json['is_leaderboard'] as num?)?.toInt(),
      name: json['name'] as String?,
      start_date: json['start_date'] as String?,
      end_date: json['end_date'] as String?,
      slug: json['slug'] as String?,
      series_status: json['series_status'] as String?,
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$SeriesItemToJson(SeriesItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_leaderboard': instance.is_leaderboard,
      'name': instance.name,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'slug': instance.slug,
      'series_status': instance.series_status,
      'created_at': instance.created_at,
    };

SeriesResponse _$SeriesResponseFromJson(Map<String, dynamic> json) =>
    SeriesResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      url: json['url'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => SeriesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeriesResponseToJson(SeriesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'url': instance.url,
      'result': instance.result,
    };
