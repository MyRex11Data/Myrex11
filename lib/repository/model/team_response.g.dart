// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: (json['id'] as num?)?.toInt(),
      playing_11: (json['playing_11'] as num?)?.toInt(),
      captain: (json['captain'] as num?)?.toInt(),
      vicecaptain: (json['vicecaptain'] as num?)?.toInt(),
      is_visible_last_match_played:
          (json['is_visible_last_match_played'] as num?)?.toInt(),
      is_playing_show: (json['is_playing_show'] as num?)?.toInt(),
      is_playing: (json['is_playing'] as num?)?.toInt(),
      last_match: (json['last_match'] as num?)?.toInt(),
      role: json['role'] as String?,
      short_role: json['short_role'] as String?,
      display_role: json['display_role'] as String?,
      playerkey: json['playerkey'] as String?,
      name: json['name'] as String?,
      teamcolor: json['teamcolor'] as String?,
      team: json['team'] as String?,
      selected_by: json['selected_by'] as String?,
      captain_selected_by: json['captain_selected_by'] as String?,
      vice_captain_selected_by: json['vice_captain_selected_by'] as String?,
      last_match_played_info_text:
          json['last_match_played_info_text'] as String?,
      teamcode: json['teamcode'] as String?,
      is_substitute: (json['is_substitute'] as num?)?.toInt(),
      image: json['image'] as String?,
      captaionText: json['captaionText'] as String?,
      vCaptainText: json['vCaptainText'] as String?,
      last_match_text: json['last_match_text'] as String?,
      isSelected: json['isSelected'] as bool?,
      isHeader: json['isHeader'] as bool?,
      count: (json['count'] as num?)?.toInt(),
      isCaptain: json['isCaptain'],
      isVcCaptain: json['isVcCaptain'],
      credit: json['credit'],
      points: json['points'],
      series_points: json['series_points'],
      last_played_points: (json['last_played_points'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      batting_order: json['batting_order'],
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'playing_11': instance.playing_11,
      'captain': instance.captain,
      'vicecaptain': instance.vicecaptain,
      'is_visible_last_match_played': instance.is_visible_last_match_played,
      'is_playing_show': instance.is_playing_show,
      'is_playing': instance.is_playing,
      'is_substitute': instance.is_substitute,
      'last_match': instance.last_match,
      'role': instance.role,
      'short_role': instance.short_role,
      'display_role': instance.display_role,
      'playerkey': instance.playerkey,
      'name': instance.name,
      'teamcolor': instance.teamcolor,
      'team': instance.team,
      'selected_by': instance.selected_by,
      'captain_selected_by': instance.captain_selected_by,
      'vice_captain_selected_by': instance.vice_captain_selected_by,
      'last_match_played_info_text': instance.last_match_played_info_text,
      'teamcode': instance.teamcode,
      'image': instance.image,
      'captaionText': instance.captaionText,
      'vCaptainText': instance.vCaptainText,
      'last_match_text': instance.last_match_text,
      'batting_order': instance.batting_order,
      'isSelected': instance.isSelected,
      'isHeader': instance.isHeader,
      'count': instance.count,
      'isCaptain': instance.isCaptain,
      'isVcCaptain': instance.isVcCaptain,
      'credit': instance.credit,
      'points': instance.points,
      'series_points': instance.series_points,
      'last_played_points': instance.last_played_points,
    };

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      teamid: (json['teamid'] as num?)?.toInt(),
      userid: (json['userid'] as num?)?.toInt(),
      teamnumber: (json['teamnumber'] as num?)?.toInt(),
      is_joined: (json['is_joined'] as num?)?.toInt(),
      sport_key: json['sport_key'] as String?,
      matchkey: json['matchkey'] as String?,
      image: json['image'] as String?,
      team1_name: json['team1_name'] as String?,
      team2_name: json['team2_name'] as String?,
      team1_player_count: json['team1_player_count'],
      team2_player_count: json['team2_player_count'],
      isSelected: json['isSelected'] as bool?,
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      points: json['points'],
      is_non_playing_players: (json['is_non_playing_players'] as num?)?.toInt(),
      is_substitute_players: (json['is_substitute_players'] as num?)?.toInt(),
      is_non_playing_players_text:
          json['is_non_playing_players_text'] as String?,
      is_substitute_text: json['is_substitute_text'] as String?,
      fantasy_type_id: json['fantasy_type_id'],
      fantasytype: json['fantasytype'],
      team_share_link: json['team_share_link'] as String?,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'teamid': instance.teamid,
      'userid': instance.userid,
      'teamnumber': instance.teamnumber,
      'is_joined': instance.is_joined,
      'sport_key': instance.sport_key,
      'matchkey': instance.matchkey,
      'image': instance.image,
      'team1_name': instance.team1_name,
      'team2_name': instance.team2_name,
      'team1_player_count': instance.team1_player_count,
      'team2_player_count': instance.team2_player_count,
      'isSelected': instance.isSelected,
      'players': instance.players,
      'is_non_playing_players': instance.is_non_playing_players,
      'is_substitute_players': instance.is_substitute_players,
      'is_non_playing_players_text': instance.is_non_playing_players_text,
      'is_substitute_text': instance.is_substitute_text,
      'points': instance.points,
      'fantasy_type_id': instance.fantasy_type_id,
      'fantasytype': instance.fantasytype,
      'team_share_link': instance.team_share_link,
    };

TeamItem _$TeamItemFromJson(Map<String, dynamic> json) => TeamItem(
      user_teams: (json['user_teams'] as num?)?.toInt(),
      joined_leagues: (json['joined_leagues'] as num?)?.toInt(),
      teams: (json['teams'] as List<dynamic>?)
          ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamItemToJson(TeamItem instance) => <String, dynamic>{
      'user_teams': instance.user_teams,
      'joined_leagues': instance.joined_leagues,
      'teams': instance.teams,
    };

MyTeamResponse _$MyTeamResponseFromJson(Map<String, dynamic> json) =>
    MyTeamResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : TeamItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyTeamResponseToJson(MyTeamResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
