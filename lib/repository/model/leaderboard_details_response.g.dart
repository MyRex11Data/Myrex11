// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardMatchData _$LeaderboardMatchDataFromJson(
        Map<String, dynamic> json) =>
    LeaderboardMatchData(
      teamid: (json['teamid'] as num?)?.toInt(),
      challenge_id: (json['challenge_id'] as num?)?.toInt(),
      points: json['points'] as String?,
      match_name: json['match_name'] as String?,
      match_date: json['match_date'] as String?,
      teamname: json['teamname'] as String?,
      sport_key: json['sport_key'] as String?,
    );

Map<String, dynamic> _$LeaderboardMatchDataToJson(
        LeaderboardMatchData instance) =>
    <String, dynamic>{
      'teamid': instance.teamid,
      'challenge_id': instance.challenge_id,
      'points': instance.points,
      'match_name': instance.match_name,
      'match_date': instance.match_date,
      'teamname': instance.teamname,
      'sport_key': instance.sport_key,
    };

LeaderboardDetailsResponse _$LeaderboardDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    LeaderboardDetailsResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      series_date: json['series_date'] as String?,
      series_name: json['series_name'] as String?,
      image: json['image'] as String?,
      name: json['name'] as String?,
      week_number: json['week_number'],
      amount: json['amount'],
      points: json['points'],
      rank: json['rank'],
      match_list: (json['match_list'] as List<dynamic>?)
          ?.map((e) => LeaderboardMatchData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LeaderboardDetailsResponseToJson(
        LeaderboardDetailsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'series_date': instance.series_date,
      'series_name': instance.series_name,
      'image': instance.image,
      'name': instance.name,
      'week_number': instance.week_number,
      'amount': instance.amount,
      'points': instance.points,
      'rank': instance.rank,
      'match_list': instance.match_list,
    };
