// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_preview_point_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPointResponseItem _$TeamPointResponseItemFromJson(
        Map<String, dynamic> json) =>
    TeamPointResponseItem(
      teamname: json['teamname'] as String?,
      teamnumber: (json['teamnumber'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toDouble(),
      bowler: (json['bowler'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      keeper: (json['keeper'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      allrounder: (json['allrounder'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      batsman: (json['batsman'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Forward: (json['Forward'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Goalkeeper: (json['Goalkeeper'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Midfielder: (json['Midfielder'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Defender: (json['Defender'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Outfielder: (json['Outfielder'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Infielder: (json['Infielder'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Pitcher: (json['Pitcher'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      Catcher: (json['Catcher'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      pgList: (json['Point guard'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      sgList: (json['Shooting guard'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      smallForwardList: (json['Small forward'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      powerForwardList: (json['Power forward'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      centreList: (json['Center'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      match_details: json['match_details'] == null
          ? null
          : MatchDetails.fromJson(
              json['match_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamPointResponseItemToJson(
        TeamPointResponseItem instance) =>
    <String, dynamic>{
      'teamname': instance.teamname,
      'teamnumber': instance.teamnumber,
      'status': instance.status,
      'points': instance.points,
      'bowler': instance.bowler,
      'keeper': instance.keeper,
      'allrounder': instance.allrounder,
      'batsman': instance.batsman,
      'Forward': instance.Forward,
      'Goalkeeper': instance.Goalkeeper,
      'Midfielder': instance.Midfielder,
      'Defender': instance.Defender,
      'Outfielder': instance.Outfielder,
      'Infielder': instance.Infielder,
      'Pitcher': instance.Pitcher,
      'Catcher': instance.Catcher,
      'Point guard': instance.pgList,
      'Shooting guard': instance.sgList,
      'Small forward': instance.smallForwardList,
      'Power forward': instance.powerForwardList,
      'Center': instance.centreList,
      'match_details': instance.match_details,
    };

TeamPointPreviewResponse _$TeamPointPreviewResponseFromJson(
        Map<String, dynamic> json) =>
    TeamPointPreviewResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : TeamPointResponseItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamPointPreviewResponseToJson(
        TeamPointPreviewResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
