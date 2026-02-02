// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_leaderboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WinningBreakupDataModel _$WinningBreakupDataModelFromJson(
        Map<String, dynamic> json) =>
    WinningBreakupDataModel(
      price: json['price'],
      position: json['position'],
      gadgets_image: json['gadgets_image'],
      is_gadgets: json['is_gadgets'],
      gadgets_name: json['gadgets_name'],
    );

Map<String, dynamic> _$WinningBreakupDataModelToJson(
        WinningBreakupDataModel instance) =>
    <String, dynamic>{
      'price': instance.price,
      'position': instance.position,
      'gadgets_image': instance.gadgets_image,
      'is_gadgets': instance.is_gadgets,
      'gadgets_name': instance.gadgets_name,
    };

SeriesLeaderboardDataModel _$SeriesLeaderboardDataModelFromJson(
        Map<String, dynamic> json) =>
    SeriesLeaderboardDataModel(
      id: json['id'],
      user_id: json['user_id'],
      series_id: json['series_id'],
      points: json['points'],
      rank: json['rank'],
      status: json['status'],
      team: json['team'] as String?,
      image: json['image'] as String?,
      promoter_leaderboard_id:
          (json['promoter_leaderboard_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SeriesLeaderboardDataModelToJson(
        SeriesLeaderboardDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'series_id': instance.series_id,
      'points': instance.points,
      'rank': instance.rank,
      'status': instance.status,
      'team': instance.team,
      'image': instance.image,
      'promoter_leaderboard_id': instance.promoter_leaderboard_id,
    };

SeriesLeaderbardData _$SeriesLeaderbardDataFromJson(
        Map<String, dynamic> json) =>
    SeriesLeaderbardData(
      leaderboard: (json['leaderboard'] as List<dynamic>?)
          ?.map((e) =>
              SeriesLeaderboardDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      wining_breakup: (json['wining_breakup'] as List<dynamic>?)
          ?.map((e) =>
              WinningBreakupDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeriesLeaderbardDataToJson(
        SeriesLeaderbardData instance) =>
    <String, dynamic>{
      'leaderboard': instance.leaderboard,
      'wining_breakup': instance.wining_breakup,
    };

SeriesLeaderboardResponse _$SeriesLeaderboardResponseFromJson(
        Map<String, dynamic> json) =>
    SeriesLeaderboardResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      total_pages: (json['total_pages'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : SeriesLeaderbardData.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeriesLeaderboardResponseToJson(
        SeriesLeaderboardResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'total_pages': instance.total_pages,
      'result': instance.result,
    };
