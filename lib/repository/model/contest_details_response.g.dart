// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinedContestTeam _$JoinedContestTeamFromJson(Map<String, dynamic> json) =>
    JoinedContestTeam(
      userrank: json['userrank'] as String?,
      team1display: json['team1display'] as String?,
      totalwinners: (json['totalwinners'] as num?)?.toInt(),
      entryfee: json['entryfee'],
      getjoinedpercentage: (json['getjoinedpercentage'] as num?)?.toInt(),
      joinedusers: (json['joinedusers'] as num?)?.toInt(),
      is_running: (json['is_running'] as num?)?.toInt(),
      join_with: (json['join_with'] as num?)?.toInt(),
      confirmed_challenge: (json['confirmed_challenge'] as num?)?.toInt(),
      is_bonus: (json['is_bonus'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      currentTeamCount: (json['currentTeamCount'] as num?)?.toInt(),
      win_amount: json['win_amount'],
      maximum_user: (json['maximum_user'] as num?)?.toInt(),
      userid: (json['userid'] as num?)?.toInt(),
      challenge_id: (json['challenge_id'] as num?)?.toInt(),
      team_id: (json['team_id'] as num?)?.toInt(),
      join_id: (json['join_id'] as num?)?.toInt(),
      is_winning_zone: json['is_winning_zone'],
      isjoined: json['isjoined'] as bool?,
      isselected: json['isselected'] as bool?,
      isSelected: json['isSelected'] as bool?,
      matchkey: json['matchkey'] as String?,
      multi_entry: json['multi_entry'],
      isselectedid: json['isselectedid'] as String?,
      points: json['points'] as String?,
      refercode: json['refercode'] as String?,
      name: json['name'] as String?,
      team2display: json['team2display'] as String?,
      user_image: json['user_image'] as String?,
      teamname: json['teamname'] as String?,
      is_champion: (json['is_champion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JoinedContestTeamToJson(JoinedContestTeam instance) =>
    <String, dynamic>{
      'userrank': instance.userrank,
      'team1display': instance.team1display,
      'totalwinners': instance.totalwinners,
      'entryfee': instance.entryfee,
      'getjoinedpercentage': instance.getjoinedpercentage,
      'joinedusers': instance.joinedusers,
      'is_running': instance.is_running,
      'join_with': instance.join_with,
      'confirmed_challenge': instance.confirmed_challenge,
      'is_bonus': instance.is_bonus,
      'id': instance.id,
      'currentTeamCount': instance.currentTeamCount,
      'win_amount': instance.win_amount,
      'maximum_user': instance.maximum_user,
      'userid': instance.userid,
      'challenge_id': instance.challenge_id,
      'team_id': instance.team_id,
      'join_id': instance.join_id,
      'is_winning_zone': instance.is_winning_zone,
      'isjoined': instance.isjoined,
      'isselected': instance.isselected,
      'isSelected': instance.isSelected,
      'matchkey': instance.matchkey,
      'multi_entry': instance.multi_entry,
      'isselectedid': instance.isselectedid,
      'points': instance.points,
      'refercode': instance.refercode,
      'name': instance.name,
      'team2display': instance.team2display,
      'user_image': instance.user_image,
      'teamname': instance.teamname,
      'is_champion': instance.is_champion,
    };

ContestDetailItem _$ContestDetailItemFromJson(Map<String, dynamic> json) =>
    ContestDetailItem(
      contest: (json['contest'] as List<dynamic>?)
          ?.map((e) => JoinedContestTeam.fromJson(e as Map<String, dynamic>))
          .toList(),
      totaljoin: json['totaljoin'],
    );

Map<String, dynamic> _$ContestDetailItemToJson(ContestDetailItem instance) =>
    <String, dynamic>{
      'contest': instance.contest,
      'totaljoin': instance.totaljoin,
    };

ContestDetailResponse _$ContestDetailResponseFromJson(
        Map<String, dynamic> json) =>
    ContestDetailResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : ContestDetailItem.fromJson(json['result'] as Map<String, dynamic>),
      pages_status: json['pages_status'],
    );

Map<String, dynamic> _$ContestDetailResponseToJson(
        ContestDetailResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'pages_status': instance.pages_status,
      'result': instance.result,
    };
