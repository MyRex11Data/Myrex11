// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_team_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComparePlayer _$ComparePlayerFromJson(Map<String, dynamic> json) =>
    ComparePlayer(
      team: json['team'],
      playercredit: json['playercredit'],
      playerpoints: json['playerpoints'],
      team_id: json['team_id'],
      pid: (json['pid'] as num?)?.toInt(),
      playerrole: json['playerrole'] as String?,
      role: json['role'] as String?,
      playername: json['playername'] as String?,
      image: json['image'] as String?,
      teamcode: json['teamcode'] as String?,
    );

Map<String, dynamic> _$ComparePlayerToJson(ComparePlayer instance) =>
    <String, dynamic>{
      'team': instance.team,
      'playercredit': instance.playercredit,
      'playerpoints': instance.playerpoints,
      'team_id': instance.team_id,
      'pid': instance.pid,
      'playerrole': instance.playerrole,
      'role': instance.role,
      'playername': instance.playername,
      'image': instance.image,
      'teamcode': instance.teamcode,
    };

TeamPlayers _$TeamPlayersFromJson(Map<String, dynamic> json) => TeamPlayers(
      player_data: (json['player_data'] as List<dynamic>?)
          ?.map((e) => ComparePlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamPlayersToJson(TeamPlayers instance) =>
    <String, dynamic>{
      'player_data': instance.player_data,
    };

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
      diff_text: json['diff_text'] as String?,
      diff_points: json['diff_points'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TeamPlayers.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'diff_text': instance.diff_text,
      'diff_points': instance.diff_points,
      'data': instance.data,
    };

CompareData _$CompareDataFromJson(Map<String, dynamic> json) => CompareData(
      team1_name: json['team1_name'] as String?,
      team2_name: json['team2_name'] as String?,
      team1_rank: json['team1_rank'] as String?,
      team2_rank: json['team2_rank'] as String?,
      team1_image: json['team1_image'] as String?,
      team2_image: json['team2_image'] as String?,
      diff_text: json['diff_text'] as String?,
      team1_points: json['team1_points'],
      team2_points: json['team2_points'],
      diff_points: json['diff_points'],
      player_list: (json['player_list'] as List<dynamic>?)
          ?.map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompareDataToJson(CompareData instance) =>
    <String, dynamic>{
      'team1_name': instance.team1_name,
      'team2_name': instance.team2_name,
      'team1_rank': instance.team1_rank,
      'team2_rank': instance.team2_rank,
      'team1_image': instance.team1_image,
      'team2_image': instance.team2_image,
      'diff_text': instance.diff_text,
      'team1_points': instance.team1_points,
      'team2_points': instance.team2_points,
      'diff_points': instance.diff_points,
      'player_list': instance.player_list,
    };

CompareTeamResponse _$CompareTeamResponseFromJson(Map<String, dynamic> json) =>
    CompareTeamResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : CompareData.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompareTeamResponseToJson(
        CompareTeamResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
