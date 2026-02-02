// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_contest_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contest _$ContestFromJson(Map<String, dynamic> json) => Contest(
      is_gstbonus: (json['is_gstbonus'] as num?)?.toInt(),
      challenge_id: (json['challenge_id'] as num?)?.toInt(),
      entryfee: json['entryfee'],
      first_rank_prize: json['first_rank_prize'],
      getjoinedpercentage: json['getjoinedpercentage'],
      dis_price: json['dis_price'] as String?,
      challenge_type: json['challenge_type'] as String?,
      real_entry_fees: (json['real_entry_fees'] as num?)?.toInt(),
      matchkey: json['matchkey'] as String?,
      isselectedid: json['isselectedid'] as String?,
      refercode: json['refercode'] as String?,
      is_fav_pin_contest: (json['is_fav_pin_contest'] as num?)?.toInt(),
      name: json['name'] as String?,
      bonus_percent: json['bonus_percent'],
      pdf: json['pdf'] as String?,
      announcement: json['announcement'] as String?,
      first_time_free_amount: (json['first_time_free_amount'] as num?)?.toInt(),
      winning_percentage: (json['winning_percentage'] as num?)?.toInt(),
      totalwinners: json['totalwinners'],
      joinedusers: (json['joinedusers'] as num?)?.toInt(),
      is_free: (json['is_free'] as num?)?.toInt(),
      multi_entry: (json['multi_entry'] as num?)?.toInt(),
      is_running: (json['is_running'] as num?)?.toInt(),
      confirmed_challenge: (json['confirmed_challenge'] as num?)?.toInt(),
      is_bonus: (json['is_bonus'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      win_amount: (json['win_amount'] as num?)?.toInt(),
      maximum_user: (json['maximum_user'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      max_multi_entry_user: (json['max_multi_entry_user'] as num?)?.toInt(),
      is_flexible: (json['is_flexible'] as num?)?.toInt(),
      is_fav_contest: json['is_fav_contest'],
      is_fav_visible: (json['is_fav_visible'] as num?)?.toInt(),
      real_challenge_id: (json['real_challenge_id'] as num?)?.toInt(),
      is_first_time_free: (json['is_first_time_free'] as num?)?.toInt(),
      isjoined: json['isjoined'] as bool?,
      isselected: json['isselected'] as bool?,
      is_giveaway_text: json['is_giveaway_text'] as String?,
      giveaway_color: json['giveaway_color'] as String?,
      is_giveaway_visible_text:
          (json['is_giveaway_visible_text'] as num?)?.toInt(),
      max_team_limit_exceeded_count:
          (json['max_team_limit_exceeded_count'] as num?)?.toInt(),
      is_champion: (json['is_champion'] as num?)?.toInt(),
      champion_x: json['champion_x'] as String?,
      champion_player: json['champion_player'] as String?,
      gadget_image: json['gadget_image'] as String?,
      is_offer_team: (json['is_offer_team'] as num?)?.toInt(),
      is_gadget: (json['is_gadget'] as num?)?.toInt(),
      is_join_similar_contest:
          (json['is_join_similar_contest'] as num?)?.toInt(),
      fantasy_type_id: (json['fantasy_type_id'] as num?)?.toInt(),
      is_free_for_referrer: (json['is_free_for_referrer'] as num?)?.toInt(),
      is_free_for_me: (json['is_free_for_me'] as num?)?.toInt(),
      allow_in_ban_state: (json['allow_in_ban_state'] as num?)?.toInt(),
      is_selected: json['is_selected'],
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContestToJson(Contest instance) => <String, dynamic>{
      'entryfee': instance.entryfee,
      'first_rank_prize': instance.first_rank_prize,
      'getjoinedpercentage': instance.getjoinedpercentage,
      'dis_price': instance.dis_price,
      'is_fav_pin_contest': instance.is_fav_pin_contest,
      'challenge_type': instance.challenge_type,
      'matchkey': instance.matchkey,
      'isselectedid': instance.isselectedid,
      'refercode': instance.refercode,
      'name': instance.name,
      'bonus_percent': instance.bonus_percent,
      'pdf': instance.pdf,
      'announcement': instance.announcement,
      'first_time_free_amount': instance.first_time_free_amount,
      'winning_percentage': instance.winning_percentage,
      'totalwinners': instance.totalwinners,
      'joinedusers': instance.joinedusers,
      'is_free': instance.is_free,
      'multi_entry': instance.multi_entry,
      'is_running': instance.is_running,
      'confirmed_challenge': instance.confirmed_challenge,
      'is_bonus': instance.is_bonus,
      'is_gstbonus': instance.is_gstbonus,
      'id': instance.id,
      'win_amount': instance.win_amount,
      'maximum_user': instance.maximum_user,
      'status': instance.status,
      'real_entry_fees': instance.real_entry_fees,
      'max_multi_entry_user': instance.max_multi_entry_user,
      'is_flexible': instance.is_flexible,
      'is_fav_contest': instance.is_fav_contest,
      'is_fav_visible': instance.is_fav_visible,
      'real_challenge_id': instance.real_challenge_id,
      'challenge_id': instance.challenge_id,
      'is_first_time_free': instance.is_first_time_free,
      'isjoined': instance.isjoined,
      'isselected': instance.isselected,
      'is_giveaway_text': instance.is_giveaway_text,
      'giveaway_color': instance.giveaway_color,
      'is_giveaway_visible_text': instance.is_giveaway_visible_text,
      'is_offer_team': instance.is_offer_team,
      'is_gadget': instance.is_gadget,
      'is_champion': instance.is_champion,
      'champion_player': instance.champion_player,
      'champion_x': instance.champion_x,
      'gadget_image': instance.gadget_image,
      'is_join_similar_contest': instance.is_join_similar_contest,
      'max_team_limit_exceeded_count': instance.max_team_limit_exceeded_count,
      'fantasy_type_id': instance.fantasy_type_id,
      'is_free_for_referrer': instance.is_free_for_referrer,
      'is_free_for_me': instance.is_free_for_me,
      'allow_in_ban_state': instance.allow_in_ban_state,
      'is_selected': instance.is_selected,
      'quantity': instance.quantity,
    };

CategoriesItem _$CategoriesItemFromJson(Map<String, dynamic> json) =>
    CategoriesItem(
      contest_sub_text: json['contest_sub_text'] as String?,
      contest_type_image: json['contest_type_image'] as String?,
      contest_image_url: json['contest_image_url'] as String?,
      name: json['name'] as String?,
      id: (json['id'] as num?)?.toInt(),
      total_category_leagues: (json['total_category_leagues'] as num?)?.toInt(),
      sort_order: (json['sort_order'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      is_view_more: (json['is_view_more'] as num?)?.toInt(),
      leagues: (json['leagues'] as List<dynamic>?)
          ?.map((e) => Contest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesItemToJson(CategoriesItem instance) =>
    <String, dynamic>{
      'contest_sub_text': instance.contest_sub_text,
      'contest_type_image': instance.contest_type_image,
      'contest_image_url': instance.contest_image_url,
      'name': instance.name,
      'id': instance.id,
      'total_category_leagues': instance.total_category_leagues,
      'sort_order': instance.sort_order,
      'status': instance.status,
      'is_view_more': instance.is_view_more,
      'leagues': instance.leagues,
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      total_contest: (json['total_contest'] as num?)?.toInt(),
      user_teams: (json['user_teams'] as num?)?.toInt(),
      team_id: (json['team_id'] as num?)?.toInt(),
      joined_leagues: (json['joined_leagues'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoriesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      private_contest_size_text: json['private_contest_size_text'],
      private_contest_winning_size_text:
          json['private_contest_winning_size_text'],
      private_contest_size_max: json['private_contest_size_max'],
      private_contest_size_min: json['private_contest_size_min'],
      private_contest_winning_size_max:
          json['private_contest_winning_size_max'],
      private_contest_winning_size_min:
          json['private_contest_winning_size_min'],
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'total_contest': instance.total_contest,
      'user_teams': instance.user_teams,
      'team_id': instance.team_id,
      'joined_leagues': instance.joined_leagues,
      'private_contest_size_text': instance.private_contest_size_text,
      'private_contest_winning_size_text':
          instance.private_contest_winning_size_text,
      'private_contest_size_max': instance.private_contest_size_max,
      'private_contest_size_min': instance.private_contest_size_min,
      'private_contest_winning_size_max':
          instance.private_contest_winning_size_max,
      'private_contest_winning_size_min':
          instance.private_contest_winning_size_min,
      'categories': instance.categories,
    };

CategoryByContestResponse _$CategoryByContestResponseFromJson(
        Map<String, dynamic> json) =>
    CategoryByContestResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : CategoryModel.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryByContestResponseToJson(
        CategoryByContestResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
