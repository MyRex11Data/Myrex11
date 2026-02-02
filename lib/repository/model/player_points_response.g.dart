// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_points_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiSportsPlayerBreakPointItem _$MultiSportsPlayerBreakPointItemFromJson(
        Map<String, dynamic> json) =>
    MultiSportsPlayerBreakPointItem(
      event_name: json['event_name'] as String?,
      actual: json['actual'],
      actual_points: json['actual_points'],
    );

Map<String, dynamic> _$MultiSportsPlayerBreakPointItemToJson(
        MultiSportsPlayerBreakPointItem instance) =>
    <String, dynamic>{
      'event_name': instance.event_name,
      'actual': instance.actual,
      'actual_points': instance.actual_points,
    };

MultiSportsPlayerPointItem _$MultiSportsPlayerPointItemFromJson(
        Map<String, dynamic> json) =>
    MultiSportsPlayerPointItem(
      id: (json['id'] as num?)?.toInt(),
      player_name: json['player_name'] as String?,
      team: json['team'] as String?,
      selected_by: json['selected_by'] as String?,
      captaind_by: json['captaind_by'] as String?,
      points: json['points'],
      image: json['image'] as String?,
      role: json['role'] as String?,
      short_name: json['short_name'] as String?,
      isSelected: (json['isSelected'] as num?)?.toInt(),
      is_topplayer: (json['is_topplayer'] as num?)?.toInt(),
      breakup_points: (json['breakup_points'] as List<dynamic>?)
          ?.map((e) => MultiSportsPlayerBreakPointItem.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      credit: json['credit'] as String?,
    );

Map<String, dynamic> _$MultiSportsPlayerPointItemToJson(
        MultiSportsPlayerPointItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'player_name': instance.player_name,
      'team': instance.team,
      'selected_by': instance.selected_by,
      'captaind_by': instance.captaind_by,
      'points': instance.points,
      'image': instance.image,
      'role': instance.role,
      'short_name': instance.short_name,
      'isSelected': instance.isSelected,
      'is_topplayer': instance.is_topplayer,
      'breakup_points': instance.breakup_points,
      'credit': instance.credit,
    };

PlayerPointsResponse _$PlayerPointsResponseFromJson(
        Map<String, dynamic> json) =>
    PlayerPointsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) =>
              MultiSportsPlayerPointItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayerPointsResponseToJson(
        PlayerPointsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
