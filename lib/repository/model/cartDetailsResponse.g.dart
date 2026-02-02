// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cartDetailsResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestCartResponse _$ContestCartResponseFromJson(Map<String, dynamic> json) =>
    ContestCartResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      total_cart_amount: (json['total_cart_amount'] as num?)?.toInt(),
      low_balance: (json['low_balance'] as num?)?.toInt(),
      required_balance: json['required_balance'] as String?,
      template: json['template'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => ContestCartTeam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContestCartResponseToJson(
        ContestCartResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'total_cart_amount': instance.total_cart_amount,
      'low_balance': instance.low_balance,
      'required_balance': instance.required_balance,
      'template': instance.template,
      'result': instance.result,
    };

ContestCartTeam _$ContestCartTeamFromJson(Map<String, dynamic> json) =>
    ContestCartTeam(
      matchkey: json['matchkey'] as String?,
      team_id: json['team_id'] as String?,
      team_text: json['team_text'] as String?,
      total_amount: (json['total_amount'] as num?)?.toInt(),
      contest: (json['contest'] as List<dynamic>?)
          ?.map((e) => ContestCart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContestCartTeamToJson(ContestCartTeam instance) =>
    <String, dynamic>{
      'matchkey': instance.matchkey,
      'team_id': instance.team_id,
      'team_text': instance.team_text,
      'total_amount': instance.total_amount,
      'contest': instance.contest,
    };

ContestCart _$ContestCartFromJson(Map<String, dynamic> json) => ContestCart(
      id: (json['id'] as num?)?.toInt(),
      challenge_id: (json['challenge_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      challenge_type: json['challenge_type'] as String?,
      winning_percentage: (json['winning_percentage'] as num?)?.toInt(),
      challenge_status: json['challenge_status'] as String?,
      challenge_text: json['challenge_text'] as String?,
      is_free_for_referrer: (json['is_free_for_referrer'] as num?)?.toInt(),
      entryfee: json['entryfee'] as String?,
      winning_amount: json['winning_amount'] as String?,
      win_amount: (json['win_amount'] as num?)?.toInt(),
      maximum_user: (json['maximum_user'] as num?)?.toInt(),
      getjoinedpercentage: (json['getjoinedpercentage'] as num?)?.toInt(),
      winners: json['winners'],
      userid: (json['userid'] as num?)?.toInt(),
      userrank: (json['userrank'] as num?)?.toInt(),
      team_id: (json['team_id'] as num?)?.toInt(),
      join_id: (json['join_id'] as num?)?.toInt(),
      matchkey: json['matchkey'] as String?,
      joinedusers: (json['joinedusers'] as num?)?.toInt(),
      multi_entry: (json['multi_entry'] as num?)?.toInt(),
      confirmed_challenge: (json['confirmed_challenge'] as num?)?.toInt(),
      is_running: (json['is_running'] as num?)?.toInt(),
      is_free: (json['is_free'] as num?)?.toInt(),
      is_bonus: (json['is_bonus'] as num?)?.toInt(),
      bonus_percent: json['bonus_percent'] as String?,
      isselected: json['isselected'] as bool?,
      isjoined: json['isjoined'] as bool?,
      first_rank_prize: (json['first_rank_prize'] as num?)?.toInt(),
      pdf: json['pdf'] as String?,
      challenge_category_id: (json['challenge_category_id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContestCartToJson(ContestCart instance) =>
    <String, dynamic>{
      'id': instance.id,
      'challenge_id': instance.challenge_id,
      'name': instance.name,
      'challenge_type': instance.challenge_type,
      'winning_percentage': instance.winning_percentage,
      'challenge_status': instance.challenge_status,
      'challenge_text': instance.challenge_text,
      'is_free_for_referrer': instance.is_free_for_referrer,
      'entryfee': instance.entryfee,
      'winning_amount': instance.winning_amount,
      'win_amount': instance.win_amount,
      'maximum_user': instance.maximum_user,
      'getjoinedpercentage': instance.getjoinedpercentage,
      'winners': instance.winners,
      'userid': instance.userid,
      'userrank': instance.userrank,
      'team_id': instance.team_id,
      'join_id': instance.join_id,
      'matchkey': instance.matchkey,
      'joinedusers': instance.joinedusers,
      'multi_entry': instance.multi_entry,
      'confirmed_challenge': instance.confirmed_challenge,
      'is_running': instance.is_running,
      'is_free': instance.is_free,
      'is_bonus': instance.is_bonus,
      'bonus_percent': instance.bonus_percent,
      'isselected': instance.isselected,
      'isjoined': instance.isjoined,
      'first_rank_prize': instance.first_rank_prize,
      'pdf': instance.pdf,
      'challenge_category_id': instance.challenge_category_id,
      'quantity': instance.quantity,
    };
