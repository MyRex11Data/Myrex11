// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerListItem _$BannerListItemFromJson(Map<String, dynamic> json) =>
    BannerListItem(
      id: (json['id'] as num?)?.toInt(),
      image: json['image'] as String?,
      title: json['title'] as String?,
      link: json['link'] as String?,
      type: json['type'] as String?,
      offer_code: json['offer_code'] as String?,
      series_id: json['series_id'],
      match_details: json['match_details'] == null
          ? null
          : MatchDetails.fromJson(
              json['match_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BannerListItemToJson(BannerListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'link': instance.link,
      'type': instance.type,
      'offer_code': instance.offer_code,
      'series_id': instance.series_id,
      'match_details': instance.match_details,
    };

MatchDetails _$MatchDetailsFromJson(Map<String, dynamic> json) => MatchDetails(
      id: (json['id'] as num?)?.toInt(),
      series: (json['series'] as num?)?.toInt(),
      match_status_key: (json['match_status_key'] as num?)?.toInt(),
      joined_count: (json['joined_count'] as num?)?.toInt(),
      team_count: (json['team_count'] as num?)?.toInt(),
      winning_total: json['winning_total'],
      lineup: (json['lineup'] as num?)?.toInt(),
      is_leaderboard: (json['is_leaderboard'] as num?)?.toInt(),
      is_amount_show: (json['is_amount_show'] as num?)?.toInt(),
      name: json['name'] as String?,
      short_name: json['short_name'] as String?,
      format: json['format'] as String?,
      seriesname: json['seriesname'] as String?,
      toss: json['toss'] as String?,
      team1display: json['team1display'] as String?,
      team2display: json['team2display'] as String?,
      team1name: json['team1name'] as String?,
      team2name: json['team2name'] as String?,
      matchkey: json['matchkey'] as String?,
      winnerstatus: json['winnerstatus'] as String?,
      launch_status: json['launch_status'] as String?,
      match_status: json['match_status'] as String?,
      sort_key: (json['sort_key'] as num?)?.toInt(),
      sport_key: json['sport_key'] as String?,
      final_status: json['final_status'] as String?,
      url: json['url'] as String?,
      banner_image: json['banner_image'] as String?,
      team1logo: json['team1logo'] as String?,
      team2logo: json['team2logo'] as String?,
      matchopenstatus: json['matchopenstatus'] as String?,
      matchindexing: json['matchindexing'] as String?,
      start_date: json['start_date'] as String?,
      mega_contest_prize: json['mega_contest_prize'] as String?,
      time_start: json['time_start'] as String?,
      highlights: json['highlights'],
      team1_color: json['team1_color'] as String?,
      team2_color: json['team2_color'] as String?,
      amount: json['amount'],
      match_time: json['match_time'] as String?,
      total_earned: json['total_earned'],
      giveaway_amount: json['giveaway_amount'] as String?,
      is_visible_total_earned:
          (json['is_visible_total_earned'] as num?)?.toInt(),
      is_giveaway_visible: (json['is_giveaway_visible'] as num?)?.toInt(),
      reversefantasy: (json['reversefantasy'] as num?)?.toInt(),
      secondinning: (json['secondinning'] as num?)?.toInt(),
      bowlingfantasy: (json['bowlingfantasy'] as num?)?.toInt(),
      battingfantasy: (json['battingfantasy'] as num?)?.toInt(),
      livefantasy: (json['livefantasy'] as num?)?.toInt(),
      is_fixture: (json['is_fixture'] as num?)?.toInt(),
      locktime: json['locktime'] == null
          ? null
          : Locktime.fromJson(json['locktime'] as Map<String, dynamic>),
      slotes: (json['slotes'] as List<dynamic>?)
          ?.map((e) => Slots.fromJson(e as Map<String, dynamic>))
          .toList(),
      unlimited_credit_match: (json['unlimited_credit_match'] as num?)?.toInt(),
      is_fav_pin_contest: (json['is_fav_pin_contest'] as num?)?.toInt(),
      unlimited_credit_text: json['unlimited_credit_text'] as String?,
      isaccountverified: json['isaccountverified'] as bool?,
      is_TenplusOne_format: json['is_TenplusOne_format'],
      is_fiveplusOne_format: json['is_fiveplusOne_format'],
      is_classic_format: json['is_classic_format'],
      team1player_image: json['team1player_image'] as String?,
      team2player_image: json['team2player_image'] as String?,
      match_date: json['match_date'] as String?,
      is_giveaway: (json['is_giveaway'] as num?)?.toInt(),
      giveaway_heading: json['giveaway_heading'] as String?,
      team_id: (json['team_id'] as num?)?.toInt(),
      user_teams: (json['user_teams'] as num?)?.toInt(),
      is_notification_subscribed:
          (json['is_notification_subscribed'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MatchDetailsToJson(MatchDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'series': instance.series,
      'match_status_key': instance.match_status_key,
      'joined_count': instance.joined_count,
      'team_count': instance.team_count,
      'winning_total': instance.winning_total,
      'lineup': instance.lineup,
      'is_fav_pin_contest': instance.is_fav_pin_contest,
      'is_leaderboard': instance.is_leaderboard,
      'is_amount_show': instance.is_amount_show,
      'name': instance.name,
      'short_name': instance.short_name,
      'format': instance.format,
      'seriesname': instance.seriesname,
      'toss': instance.toss,
      'team1display': instance.team1display,
      'team2display': instance.team2display,
      'team1name': instance.team1name,
      'team2name': instance.team2name,
      'matchkey': instance.matchkey,
      'winnerstatus': instance.winnerstatus,
      'launch_status': instance.launch_status,
      'match_status': instance.match_status,
      'sort_key': instance.sort_key,
      'sport_key': instance.sport_key,
      'final_status': instance.final_status,
      'url': instance.url,
      'banner_image': instance.banner_image,
      'team1logo': instance.team1logo,
      'team2logo': instance.team2logo,
      'matchopenstatus': instance.matchopenstatus,
      'matchindexing': instance.matchindexing,
      'start_date': instance.start_date,
      'match_time': instance.match_time,
      'time_start': instance.time_start,
      'mega_contest_prize': instance.mega_contest_prize,
      'highlights': instance.highlights,
      'team1_color': instance.team1_color,
      'team2_color': instance.team2_color,
      'amount': instance.amount,
      'total_earned': instance.total_earned,
      'giveaway_amount': instance.giveaway_amount,
      'is_visible_total_earned': instance.is_visible_total_earned,
      'is_giveaway_visible': instance.is_giveaway_visible,
      'reversefantasy': instance.reversefantasy,
      'secondinning': instance.secondinning,
      'bowlingfantasy': instance.bowlingfantasy,
      'battingfantasy': instance.battingfantasy,
      'livefantasy': instance.livefantasy,
      'is_fixture': instance.is_fixture,
      'locktime': instance.locktime,
      'slotes': instance.slotes,
      'unlimited_credit_match': instance.unlimited_credit_match,
      'unlimited_credit_text': instance.unlimited_credit_text,
      'isaccountverified': instance.isaccountverified,
      'is_classic_format': instance.is_classic_format,
      'is_fiveplusOne_format': instance.is_fiveplusOne_format,
      'is_TenplusOne_format': instance.is_TenplusOne_format,
      'team1player_image': instance.team1player_image,
      'team2player_image': instance.team2player_image,
      'match_date': instance.match_date,
      'is_giveaway': instance.is_giveaway,
      'giveaway_heading': instance.giveaway_heading,
      'team_id': instance.team_id,
      'user_teams': instance.user_teams,
      'is_notification_subscribed': instance.is_notification_subscribed,
    };

SportType _$SportTypeFromJson(Map<String, dynamic> json) => SportType(
      json['sport_name'] as String?,
      json['sport_key'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$SportTypeToJson(SportType instance) => <String, dynamic>{
      'sport_name': instance.sport_name,
      'sport_key': instance.sport_key,
      'image': instance.image,
    };

LeaderBoardSport _$LeaderBoardSportFromJson(Map<String, dynamic> json) =>
    LeaderBoardSport(
      json['sport_name'] as String?,
      json['sport_key'] as String?,
      json['image'] as String?,
      (json['position'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeaderBoardSportToJson(LeaderBoardSport instance) =>
    <String, dynamic>{
      'sport_name': instance.sport_name,
      'sport_key': instance.sport_key,
      'image': instance.image,
      'position': instance.position,
    };

Slots _$SlotsFromJson(Map<String, dynamic> json) => Slots(
      id: (json['id'] as num?)?.toInt(),
      type: json['type'] as String?,
      min_over: (json['min_over'] as num?)?.toDouble(),
      max_over: (json['max_over'] as num?)?.toDouble(),
      inning: (json['inning'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SlotsToJson(Slots instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'min_over': instance.min_over,
      'max_over': instance.max_over,
      'inning': instance.inning,
    };

Locktime _$LocktimeFromJson(Map<String, dynamic> json) => Locktime(
      date: json['date'] as String?,
      timezone: json['timezone'] as String?,
      timezone_type: (json['timezone_type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LocktimeToJson(Locktime instance) => <String, dynamic>{
      'date': instance.date,
      'timezone': instance.timezone,
      'timezone_type': instance.timezone_type,
    };

Sport_radious _$Sport_radiousFromJson(Map<String, dynamic> json) =>
    Sport_radious(
      radiusX: (json['radiusX'] as num?)?.toDouble(),
      radiusY: (json['radiusY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$Sport_radiousToJson(Sport_radious instance) =>
    <String, dynamic>{
      'radiusX': instance.radiusX,
      'radiusY': instance.radiusY,
    };

BannerListResponse _$BannerListResponseFromJson(Map<String, dynamic> json) =>
    BannerListResponse(
      slide: (json['slide'] as List<dynamic>?)
          ?.map((e) => Slide.fromJson(e as Map<String, dynamic>))
          .toList(),
      is_series_matches_slides:
          (json['is_series_matches_slides'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      refer_url: json['refer_url'] as String?,
      is_popup_redirect: (json['is_popup_redirect'] as num?)?.toInt(),
      version: (json['version'] as num?)?.toInt(),
      is_visible_affiliate: (json['is_visible_affiliate'] as num?)?.toInt(),
      is_visible_promote: (json['is_visible_promote'] as num?)?.toInt(),
      is_visible_promoter_leaderboard:
          (json['is_visible_promoter_leaderboard'] as num?)?.toInt(),
      is_visible_promoter_requested:
          (json['is_visible_promoter_requested'] as num?)?.toInt(),
      message: json['message'] as String?,
      popup_link: json['popup_link'] as String?,
      version_code: (json['version_code'] as num?)?.toInt(),
      version_changes: json['version_changes'] as String?,
      app_download_url: json['app_download_url'] as String?,
      base_url: json['base_url'] as String?,
      api_base_url: json['api_base_url'] as String?,
      popup_status: (json['popup_status'] as num?)?.toInt(),
      popup_image: json['popup_image'] as String?,
      poup_time: (json['poup_time'] as num?)?.toInt(),
      show_popup: (json['show_popup'] as num?)?.toInt(),
      notification: (json['notification'] as num?)?.toInt(),
      team: json['team'] as String?,
      state: json['state'] as String?,
      popup_type: json['popup_type'] as String?,
      popup_url: json['popup_url'] as String?,
      popup_redirect_type: json['popup_redirect_type'] as String?,
      is_withdraw: json['is_withdraw'] as String?,
      is_inst_withdraw: json['is_inst_withdraw'] as String?,
      is_promotor_withdraw: json['is_promotor_withdraw'] as String?,
      is_promotor_inst_withdraw: json['is_promotor_inst_withdraw'] as String?,
      popup_series_id: json['popup_series_id'],
      popup_offer_code: json['popup_offer_code'],
      match_details: json['match_details'] == null
          ? null
          : MatchDetails.fromJson(
              json['match_details'] as Map<String, dynamic>),
      visible_sports: (json['visible_sports'] as List<dynamic>?)
          ?.map((e) => SportType.fromJson(e as Map<String, dynamic>))
          .toList(),
      sport_leaderboard: (json['sport_leaderboard'] as List<dynamic>?)
          ?.map((e) => LeaderBoardSport.fromJson(e as Map<String, dynamic>))
          .toList(),
      sport_radious: json['sport_radious'] == null
          ? null
          : Sport_radious.fromJson(
              json['sport_radious'] as Map<String, dynamic>),
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => BannerListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      email_verify: (json['email_verify'] as num?)?.toInt(),
      bank_verify: (json['bank_verify'] as num?)?.toInt(),
      mobile_verify: (json['mobile_verify'] as num?)?.toInt(),
      pan_verify: (json['pan_verify'] as num?)?.toInt(),
      aadhar_verify: (json['aadhar_verify'] as num?)?.toInt(),
      gst_deduct: json['gst_deduct'],
      gst_rebat: json['gst_rebat'],
      gst_bonus: (json['gst_bonus'] as num?)?.toInt(),
      version_code_playstore: (json['version_code_playstore'] as num?)?.toInt(),
      winning_commission: json['winning_commission'],
      is_deposit_leaderbord: json['is_deposit_leaderbord'],
      is_investment_leaderboard: json['is_investment_leaderboard'],
      is_series_leaderboard: json['is_series_leaderboard'],
      version_code_ios: (json['version_code_ios'] as num?)?.toInt(),
      max_team_add_limit: json['max_team_add_limit'],
      max_deposit: json['max_deposit'] as String?,
      min_deposit: json['min_deposit'] as String?,
      min_inst_withdraw: json['min_inst_withdraw'] as String?,
      max_inst_withdraw: json['max_inst_withdraw'] as String?,
      min_withdraw: json['min_withdraw'] as String?,
      max_withdraw: json['max_withdraw'] as String?,
      winning_to_transfer_min: json['winning_to_transfer_min'] as String?,
      winning_to_transfer_max: json['winning_to_transfer_max'] as String?,
      winning_to_transfer_per_day_limit:
          json['winning_to_transfer_per_day_limit'] as String?,
      winning_to_deposit_extra_commission:
          json['winning_to_deposit_extra_commission'] as String?,
      show_phonepe: json['show_phonepe'] as String?,
      show_nttpay: json['show_nttpay'] as String?,
      show_razorpay: json['show_razorpay'] as String?,
      cashfree: json['cashfree'] as String?,
      address_verify_show: (json['address_verify_show'] as num?)?.toInt(),
      address_verify: (json['address_verify'] as num?)?.toInt(),
      banned_state: (json['banned_state'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      address_doc_type:
          (json['address_doc_type'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      show_phonepe_text: json['show_phonepe_text'] as String?,
      show_nttpay_text: json['show_nttpay_text'] as String?,
      show_cashfree_text: json['show_cashfree_text'] as String?,
      refer_bonus_amount: json['refer_bonus_amount'] as String?,
      sign_up_bonus_amount: json['sign_up_bonus_amount'] as String?,
      show_upi_verification: json['show_upi_verification'] as String?,
      private_contest: json['private_contest'] as String?,
      max_team_limit: (json['max_team_limit'] as num?)?.toInt(),
      forced_update: (json['forced_update'] as num?)?.toInt(),
      show_update_popuop: (json['show_update_popuop'] as num?)?.toInt(),
      version_android_ios: (json['version_android_ios'] as num?)?.toInt(),
      app_store_url: json['app_store_url'] as String?,
      show_affiliate_wallet: (json['show_affiliate_wallet'] as num?)?.toInt(),
      show_affiliate_wallet_withdraw:
          (json['show_affiliate_wallet_withdraw'] as num?)?.toInt(),
      similer_join_contest_list:
          (json['similer_join_contest_list'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      is_myaccount_enabled: (json['is_myaccount_enabled'] as num?)?.toInt(),
      contact_us: json['contact_us'] == null
          ? null
          : ContactInfo.fromJson(json['contact_us'] as Map<String, dynamic>),
      cashfree_mode: (json['cashfree_mode'] as num?)?.toInt(),
      external_pages: json['external_pages'] == null
          ? null
          : ExternalPages.fromJson(
              json['external_pages'] as Map<String, dynamic>),
      whatsapp_url: json['whatsapp_url'] as String?,
      show_whatsapp_support: json['show_whatsapp_support'] as String?,
      show_telegram_support: json['show_telegram_support'] as String?,
      show_refer_earn: json['show_refer_earn'] as String?,
      show_refer_list: json['show_refer_list'] as String?,
      total_referal_all: (json['total_referal_all'] as num?)?.toInt(),
      cart_feature_enable: json['cart_feature_enable'] as String?,
    )..telegram_url = json['telegram_url'] as String?;

Map<String, dynamic> _$BannerListResponseToJson(BannerListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'is_popup_redirect': instance.is_popup_redirect,
      'version': instance.version,
      'gst_rebat': instance.gst_rebat,
      'gst_deduct': instance.gst_deduct,
      'winning_commission': instance.winning_commission,
      'is_visible_affiliate': instance.is_visible_affiliate,
      'is_visible_promote': instance.is_visible_promote,
      'is_visible_promoter_leaderboard':
          instance.is_visible_promoter_leaderboard,
      'is_visible_promoter_requested': instance.is_visible_promoter_requested,
      'message': instance.message,
      'popup_link': instance.popup_link,
      'version_code': instance.version_code,
      'version_changes': instance.version_changes,
      'app_download_url': instance.app_download_url,
      'refer_url': instance.refer_url,
      'base_url': instance.base_url,
      'api_base_url': instance.api_base_url,
      'popup_status': instance.popup_status,
      'popup_image': instance.popup_image,
      'poup_time': instance.poup_time,
      'show_popup': instance.show_popup,
      'notification': instance.notification,
      'email_verify': instance.email_verify,
      'bank_verify': instance.bank_verify,
      'mobile_verify': instance.mobile_verify,
      'pan_verify': instance.pan_verify,
      'aadhar_verify': instance.aadhar_verify,
      'team': instance.team,
      'state': instance.state,
      'popup_type': instance.popup_type,
      'popup_url': instance.popup_url,
      'popup_redirect_type': instance.popup_redirect_type,
      'is_withdraw': instance.is_withdraw,
      'is_inst_withdraw': instance.is_inst_withdraw,
      'is_promotor_withdraw': instance.is_promotor_withdraw,
      'is_promotor_inst_withdraw': instance.is_promotor_inst_withdraw,
      'popup_series_id': instance.popup_series_id,
      'popup_offer_code': instance.popup_offer_code,
      'match_details': instance.match_details,
      'visible_sports': instance.visible_sports,
      'sport_leaderboard': instance.sport_leaderboard,
      'sport_radious': instance.sport_radious,
      'result': instance.result,
      'is_series_matches_slides': instance.is_series_matches_slides,
      'slide': instance.slide,
      'gst_bonus': instance.gst_bonus,
      'version_code_playstore': instance.version_code_playstore,
      'version_code_ios': instance.version_code_ios,
      'is_deposit_leaderbord': instance.is_deposit_leaderbord,
      'is_investment_leaderboard': instance.is_investment_leaderboard,
      'is_series_leaderboard': instance.is_series_leaderboard,
      'max_team_add_limit': instance.max_team_add_limit,
      'min_deposit': instance.min_deposit,
      'max_deposit': instance.max_deposit,
      'min_inst_withdraw': instance.min_inst_withdraw,
      'max_inst_withdraw': instance.max_inst_withdraw,
      'min_withdraw': instance.min_withdraw,
      'max_withdraw': instance.max_withdraw,
      'winning_to_transfer_min': instance.winning_to_transfer_min,
      'winning_to_transfer_max': instance.winning_to_transfer_max,
      'winning_to_transfer_per_day_limit':
          instance.winning_to_transfer_per_day_limit,
      'winning_to_deposit_extra_commission':
          instance.winning_to_deposit_extra_commission,
      'show_phonepe': instance.show_phonepe,
      'show_nttpay': instance.show_nttpay,
      'show_razorpay': instance.show_razorpay,
      'cashfree': instance.cashfree,
      'address_verify_show': instance.address_verify_show,
      'address_verify': instance.address_verify,
      'banned_state': instance.banned_state,
      'address_doc_type': instance.address_doc_type,
      'show_phonepe_text': instance.show_phonepe_text,
      'show_nttpay_text': instance.show_nttpay_text,
      'show_cashfree_text': instance.show_cashfree_text,
      'refer_bonus_amount': instance.refer_bonus_amount,
      'sign_up_bonus_amount': instance.sign_up_bonus_amount,
      'show_upi_verification': instance.show_upi_verification,
      'private_contest': instance.private_contest,
      'max_team_limit': instance.max_team_limit,
      'forced_update': instance.forced_update,
      'show_update_popuop': instance.show_update_popuop,
      'version_android_ios': instance.version_android_ios,
      'app_store_url': instance.app_store_url,
      'show_affiliate_wallet': instance.show_affiliate_wallet,
      'show_affiliate_wallet_withdraw': instance.show_affiliate_wallet_withdraw,
      'similer_join_contest_list': instance.similer_join_contest_list,
      'is_myaccount_enabled': instance.is_myaccount_enabled,
      'contact_us': instance.contact_us,
      'cashfree_mode': instance.cashfree_mode,
      'external_pages': instance.external_pages,
      'whatsapp_url': instance.whatsapp_url,
      'telegram_url': instance.telegram_url,
      'show_whatsapp_support': instance.show_whatsapp_support,
      'show_telegram_support': instance.show_telegram_support,
      'show_refer_earn': instance.show_refer_earn,
      'show_refer_list': instance.show_refer_list,
      'total_referal_all': instance.total_referal_all,
      'cart_feature_enable': instance.cart_feature_enable,
    };

addressDocType _$addressDocTypeFromJson(Map<String, dynamic> json) =>
    addressDocType(
      aadhar: json['aadhar'] as String?,
      voter: json['voter'] as String?,
    );

Map<String, dynamic> _$addressDocTypeToJson(addressDocType instance) =>
    <String, dynamic>{
      'aadhar': instance.aadhar,
      'voter': instance.voter,
    };

Slide _$SlideFromJson(Map<String, dynamic> json) => Slide(
      series_name: json['series_name'] as String?,
      series_id: (json['series_id'] as num?)?.toInt(),
      is_leaderboard: (json['is_leaderboard'] as num?)?.toInt(),
      matches: (json['matches'] as List<dynamic>?)
          ?.map((e) => Matches.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SlideToJson(Slide instance) => <String, dynamic>{
      'series_name': instance.series_name,
      'series_id': instance.series_id,
      'is_leaderboard': instance.is_leaderboard,
      'matches': instance.matches,
    };

Matches _$MatchesFromJson(Map<String, dynamic> json) => Matches(
      team1display: json['team1display'] as String?,
      team2display: json['team2display'] as String?,
      team1_color_code: json['team1_color_code'] as String?,
      team2_color_code: json['team2_color_code'] as String?,
      start_date: json['start_date'] as String?,
      team1logo: json['team1logo'] as String?,
      team2logo: json['team2logo'] as String?,
      matchkey: json['matchkey'] as String?,
      is_giveaway: json['is_giveaway'],
      giveaway_heading: json['giveaway_heading'] as String?,
      giveaway_subheading: json['giveaway_subheading'] as String?,
    );

Map<String, dynamic> _$MatchesToJson(Matches instance) => <String, dynamic>{
      'team1display': instance.team1display,
      'team2display': instance.team2display,
      'team1_color_code': instance.team1_color_code,
      'team2_color_code': instance.team2_color_code,
      'start_date': instance.start_date,
      'team1logo': instance.team1logo,
      'team2logo': instance.team2logo,
      'matchkey': instance.matchkey,
      'is_giveaway': instance.is_giveaway,
      'giveaway_heading': instance.giveaway_heading,
      'giveaway_subheading': instance.giveaway_subheading,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      title: json['title'] as String?,
      email_detail: json['email_detail'] as String?,
      mobile_detail: json['mobile_detail'] as String?,
      facebook: json['facebook'] as String?,
      twitter: json['twitter'] as String?,
      instagram: json['instagram'] as String?,
      telegram: json['telegram'] as String?,
      youtube: json['youtube'] as String?,
      whatsup: json['whatsup'] as String?,
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'email_detail': instance.email_detail,
      'mobile_detail': instance.mobile_detail,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'instagram': instance.instagram,
      'telegram': instance.telegram,
      'youtube': instance.youtube,
      'whatsup': instance.whatsup,
    };

ExternalPages _$ExternalPagesFromJson(Map<String, dynamic> json) =>
    ExternalPages(
      terms: json['terms'] as String?,
      fantasy_points: json['fantasy_points'] as String?,
      privacy: json['privacy'] as String?,
      about_us: json['about_us'] as String?,
      how_to_play: json['how_to_play'] as String?,
      legalities: json['legalities'] as String?,
      responsible_play: json['responsible_play'] as String?,
      fair_play: json['fair_play'] as String?,
      refund_policy: json['refund_policy'] as String?,
      help_desk: json['help_desk'] as String?,
    );

Map<String, dynamic> _$ExternalPagesToJson(ExternalPages instance) =>
    <String, dynamic>{
      'terms': instance.terms,
      'fantasy_points': instance.fantasy_points,
      'privacy': instance.privacy,
      'about_us': instance.about_us,
      'how_to_play': instance.how_to_play,
      'legalities': instance.legalities,
      'responsible_play': instance.responsible_play,
      'fair_play': instance.fair_play,
      'refund_policy': instance.refund_policy,
      'help_desk': instance.help_desk,
    };
