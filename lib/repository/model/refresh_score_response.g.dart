// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_score_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveFinishedContestData _$LiveFinishedContestDataFromJson(
        Map<String, dynamic> json) =>
    LiveFinishedContestData(
      winingamount: (json['winingamount'] as num?)?.toInt(),
      is_private: (json['is_private'] as num?)?.toInt(),
      totalwinners: json['totalwinners'],
      id: (json['id'] as num?)?.toInt(),
      minimum_user: (json['minimum_user'] as num?)?.toInt(),
      multi_entry: (json['multi_entry'] as num?)?.toInt(),
      confirmed: (json['confirmed'] as num?)?.toInt(),
      teamid: (json['teamid'] as num?)?.toInt(),
      userrank: (json['userrank'] as num?)?.toInt(),
      maximum_user: (json['maximum_user'] as num?)?.toInt(),
      can_invite: (json['can_invite'] as num?)?.toInt(),
      entryfee: json['entryfee'],
      joinedusers: (json['joinedusers'] as num?)?.toInt(),
      joinid: (json['joinid'] as num?)?.toInt(),
      grand: (json['grand'] as num?)?.toInt(),
      team_number_get: (json['team_number_get'] as num?)?.toInt(),
      win_amount: (json['win_amount'] as num?)?.toInt(),
      pdf_created: (json['pdf_created'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      confirmed_challenge: (json['confirmed_challenge'] as num?)?.toInt(),
      is_bonus: (json['is_bonus'] as num?)?.toInt(),
      max_multi_entry_user: (json['max_multi_entry_user'] as num?)?.toInt(),
      refercode: json['refercode'] as String?,
      first_rank_prize: json['first_rank_prize'],
      points: json['points'],
      matchstatus: json['matchstatus'] as String?,
      challenge_type: json['challenge_type'] as String?,
      winning_percentage: json['winning_percentage'],
      pdf: json['pdf'] as String?,
      join_with: json['join_with'] as String?,
      name: json['name'] as String?,
      winning_amount: json['winning_amount'],
      getjoinedpercentage: json['getjoinedpercentage'],
      bonus_percent: json['bonus_percent'] as String?,
      challenge_status: json['challenge_status'] as String?,
      challenge_text: json['challenge_text'] as String?,
      is_giveaway_text: json['is_giveaway_text'] as String?,
      giveaway_color: json['giveaway_color'] as String?,
      is_giveaway_visible_text:
          (json['is_giveaway_visible_text'] as num?)?.toInt(),
      recycler_item_price_card:
          (json['recycler_item_price_card'] as List<dynamic>?)
              ?.map((e) => PriceCardItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      winners_zone: (json['winners_zone'] as List<dynamic>?)
          ?.map((e) => WinnersZoneItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      is_flexible: (json['is_flexible'] as num?)?.toInt(),
      is_gadget: (json['is_gadget'] as num?)?.toInt(),
      gadget_image: json['gadget_image'] as String?,
      champion_player: json['champion_player'] as String?,
      champion_x: json['champion_x'] as String?,
      is_champion: (json['is_champion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LiveFinishedContestDataToJson(
        LiveFinishedContestData instance) =>
    <String, dynamic>{
      'winingamount': instance.winingamount,
      'is_private': instance.is_private,
      'totalwinners': instance.totalwinners,
      'id': instance.id,
      'minimum_user': instance.minimum_user,
      'multi_entry': instance.multi_entry,
      'confirmed': instance.confirmed,
      'teamid': instance.teamid,
      'userrank': instance.userrank,
      'maximum_user': instance.maximum_user,
      'can_invite': instance.can_invite,
      'entryfee': instance.entryfee,
      'joinedusers': instance.joinedusers,
      'joinid': instance.joinid,
      'grand': instance.grand,
      'team_number_get': instance.team_number_get,
      'win_amount': instance.win_amount,
      'pdf_created': instance.pdf_created,
      'status': instance.status,
      'confirmed_challenge': instance.confirmed_challenge,
      'is_bonus': instance.is_bonus,
      'max_multi_entry_user': instance.max_multi_entry_user,
      'refercode': instance.refercode,
      'first_rank_prize': instance.first_rank_prize,
      'points': instance.points,
      'matchstatus': instance.matchstatus,
      'challenge_type': instance.challenge_type,
      'winning_percentage': instance.winning_percentage,
      'pdf': instance.pdf,
      'join_with': instance.join_with,
      'name': instance.name,
      'winning_amount': instance.winning_amount,
      'getjoinedpercentage': instance.getjoinedpercentage,
      'bonus_percent': instance.bonus_percent,
      'challenge_status': instance.challenge_status,
      'challenge_text': instance.challenge_text,
      'is_giveaway_text': instance.is_giveaway_text,
      'giveaway_color': instance.giveaway_color,
      'is_giveaway_visible_text': instance.is_giveaway_visible_text,
      'recycler_item_price_card': instance.recycler_item_price_card,
      'winners_zone': instance.winners_zone,
      'is_flexible': instance.is_flexible,
      'is_champion': instance.is_champion,
      'champion_player': instance.champion_player,
      'champion_x': instance.champion_x,
      'is_gadget': instance.is_gadget,
      'gadget_image': instance.gadget_image,
    };

WinnersZoneItem _$WinnersZoneItemFromJson(Map<String, dynamic> json) =>
    WinnersZoneItem(
      rank: (json['rank'] as num?)?.toInt(),
      is_winningzone: (json['is_winningzone'] as num?)?.toInt(),
      team_id: (json['team_id'] as num?)?.toInt(),
      team_number: json['team_number'],
      team_name: json['team_name'] as String?,
      points: json['points'] as String?,
      arrowname: json['arrowname'] as String?,
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$WinnersZoneItemToJson(WinnersZoneItem instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'is_winningzone': instance.is_winningzone,
      'team_id': instance.team_id,
      'team_number': instance.team_number,
      'team_name': instance.team_name,
      'points': instance.points,
      'arrowname': instance.arrowname,
      'amount': instance.amount,
    };

PriceCardItem _$PriceCardItemFromJson(Map<String, dynamic> json) =>
    PriceCardItem(
      start_position: (json['start_position'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PriceCardItemToJson(PriceCardItem instance) =>
    <String, dynamic>{
      'start_position': instance.start_position,
      'price': instance.price,
      'id': instance.id,
    };

LiveFinishedScoreItem _$LiveFinishedScoreItemFromJson(
        Map<String, dynamic> json) =>
    LiveFinishedScoreItem(
      Team1: json['Team1'] as String?,
      Team2: json['Team2'] as String?,
      Team1_Totalovers: json['Team1_Totalovers'] as String?,
      Team1_Totalruns: json['Team1_Totalruns'] as String?,
      Team1_Totalwickets: json['Team1_Totalwickets'] as String?,
      Team2_Totalwickets: json['Team2_Totalwickets'] as String?,
      Team2_Totalovers: json['Team2_Totalovers'] as String?,
      Team2_Totalruns: json['Team2_Totalruns'] as String?,
      Winning_Status: json['Winning_Status'] as String?,
    );

Map<String, dynamic> _$LiveFinishedScoreItemToJson(
        LiveFinishedScoreItem instance) =>
    <String, dynamic>{
      'Team1': instance.Team1,
      'Team2': instance.Team2,
      'Team1_Totalovers': instance.Team1_Totalovers,
      'Team1_Totalruns': instance.Team1_Totalruns,
      'Team1_Totalwickets': instance.Team1_Totalwickets,
      'Team2_Totalwickets': instance.Team2_Totalwickets,
      'Team2_Totalovers': instance.Team2_Totalovers,
      'Team2_Totalruns': instance.Team2_Totalruns,
      'Winning_Status': instance.Winning_Status,
    };

LiveScoreByBall _$LiveScoreByBallFromJson(Map<String, dynamic> json) =>
    LiveScoreByBall(
      batter: (json['batter'] as List<dynamic>?)
          ?.map((e) => Batsman.fromJson(e as Map<String, dynamic>))
          .toList(),
      bowl: json['bowl'] == null
          ? null
          : Bowler.fromJson(json['bowl'] as Map<String, dynamic>),
      oversummeries: (json['oversummeries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      is_show_card: (json['is_show_card'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LiveScoreByBallToJson(LiveScoreByBall instance) =>
    <String, dynamic>{
      'batter': instance.batter,
      'bowl': instance.bowl,
      'oversummeries': instance.oversummeries,
      'is_show_card': instance.is_show_card,
    };

Batsman _$BatsmanFromJson(Map<String, dynamic> json) => Batsman(
      name: json['name'] as String?,
      runs: json['runs'] as String?,
    )..onstrike = (json['onstrike'] as num?)?.toInt();

Map<String, dynamic> _$BatsmanToJson(Batsman instance) => <String, dynamic>{
      'name': instance.name,
      'runs': instance.runs,
      'onstrike': instance.onstrike,
    };

Bowler _$BowlerFromJson(Map<String, dynamic> json) => Bowler(
      name: json['name'] as String?,
      runs: json['runs'] as String?,
      onstrike: (json['onstrike'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BowlerToJson(Bowler instance) => <String, dynamic>{
      'name': instance.name,
      'runs': instance.runs,
      'onstrike': instance.onstrike,
    };

RefreshScoreItem _$RefreshScoreItemFromJson(Map<String, dynamic> json) =>
    RefreshScoreItem(
      late_declared_text: json['late_declared_text'] as String?,
      is_late_declared: (json['is_late_declared'] as num?)?.toInt(),
      user_teams: (json['user_teams'] as num?)?.toInt(),
      total_profit: json['total_profit'],
      total_winning: json['total_winning'],
      total_investment: json['total_investment'],
      matchruns: (json['matchruns'] as List<dynamic>?)
          ?.map(
              (e) => LiveFinishedScoreItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      contest: (json['contest'] as List<dynamic>?)
          ?.map((e) =>
              LiveFinishedContestData.fromJson(e as Map<String, dynamic>))
          .toList(),
      show_popper: (json['show_popper'] as num?)?.toInt(),
      show_investment: (json['show_investment'] as num?)?.toInt(),
      teams: (json['teams'] as List<dynamic>?)
          ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
      match_status: json['match_status'],
      live_score_by_ball: json['live_score_by_ball'] == null
          ? null
          : LiveScoreByBall.fromJson(
              json['live_score_by_ball'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefreshScoreItemToJson(RefreshScoreItem instance) =>
    <String, dynamic>{
      'late_declared_text': instance.late_declared_text,
      'is_late_declared': instance.is_late_declared,
      'user_teams': instance.user_teams,
      'total_profit': instance.total_profit,
      'total_winning': instance.total_winning,
      'total_investment': instance.total_investment,
      'match_status': instance.match_status,
      'show_popper': instance.show_popper,
      'show_investment': instance.show_investment,
      'matchruns': instance.matchruns,
      'contest': instance.contest,
      'teams': instance.teams,
      'live_score_by_ball': instance.live_score_by_ball,
    };

RefreshScoreResponse _$RefreshScoreResponseFromJson(
        Map<String, dynamic> json) =>
    RefreshScoreResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : RefreshScoreItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RefreshScoreResponseToJson(
        RefreshScoreResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
