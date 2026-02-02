// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralRequest _$GeneralRequestFromJson(Map<String, dynamic> json) =>
    GeneralRequest(
      deposit_id: json['deposit_id'] as String?,
      gstAmount: json['gstAmount'] as String?,
      user_id: json['user_id'] as String?,
      mobile: json['mobile'] as String?,
      type: json['type'] as String?,
      file: json['file'] as String?,
      amount: json['amount'] as String?,
      email: json['email'] as String?,
      email_or_mobile: json['email_or_mobile'] as String?,
      matchkey: json['matchkey'] as String?,
      promo: json['promo'] as String?,
      payment_type: json['payment_type'] as String?,
      ip: json['ip'] as String?,
      challenge_id: json['challenge_id'] as String?,
      sport_key: json['sport_key'] as String?,
      team1_id: json['team1_id'] as String?,
      team2_id: json['team2_id'] as String?,
      series_id: json['series_id'] as String?,
      verification_type: json['verification_type'] as String?,
      start_date: json['start_date'] as String?,
      end_date: json['end_date'] as String?,
      page: json['page'] as String?,
      my_fav_contest: json['my_fav_contest'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
      promoter_leaderboard_id: json['promoter_leaderboard_id'] as String?,
      fcmToken: json['fcmToken'] as String?,
      search: json['search'] as String?,
      oldpassword: json['oldpassword'] as String?,
      newpassword: json['newpassword'] as String?,
      otp: json['otp'] as String?,
      playerid: json['playerid'] as String?,
      is_fav_pin_contest: json['is_fav_pin_contest'] as String?,
      store_id: json['store_id'] as String?,
      order_id: json['order_id'] as String?,
      currency: json['currency'] as String?,
      product_type: json['product_type'] as String?,
      product_name: json['product_name'] as String?,
      device_type: json['device_type'] as String?,
      pay_type: json['pay_type'] as String?,
      affiliate_commission: json['affiliate_commission'] as String?,
      fantasy_type_id: json['fantasy_type_id'] as String?,
      referral: json['referral'],
      buildType: json['buildType'] as String?,
      myIp: json['myIp'] as String?,
      androidId: json['androidId'] as String?,
      from_user_id: json['from_user_id'] as String?,
      is_skiped_update: (json['is_skiped_update'] as num?)?.toInt(),
      is_skiped_popup: (json['is_skiped_popup'] as num?)?.toInt(),
      is_playstore_build: (json['is_playstore_build'] as num?)?.toInt(),
      teamid: json['teamid'] as String?,
    );

Map<String, dynamic> _$GeneralRequestToJson(GeneralRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'mobile': instance.mobile,
      'type': instance.type,
      'file': instance.file,
      'amount': instance.amount,
      'email': instance.email,
      'email_or_mobile': instance.email_or_mobile,
      'matchkey': instance.matchkey,
      'promo': instance.promo,
      'payment_type': instance.payment_type,
      'ip': instance.ip,
      'challenge_id': instance.challenge_id,
      'sport_key': instance.sport_key,
      'team1_id': instance.team1_id,
      'team2_id': instance.team2_id,
      'series_id': instance.series_id,
      'verification_type': instance.verification_type,
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'page': instance.page,
      'my_fav_contest': instance.my_fav_contest,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
      'promoter_leaderboard_id': instance.promoter_leaderboard_id,
      'fcmToken': instance.fcmToken,
      'search': instance.search,
      'oldpassword': instance.oldpassword,
      'newpassword': instance.newpassword,
      'otp': instance.otp,
      'playerid': instance.playerid,
      'is_fav_pin_contest': instance.is_fav_pin_contest,
      'product_name': instance.product_name,
      'product_type': instance.product_type,
      'currency': instance.currency,
      'order_id': instance.order_id,
      'store_id': instance.store_id,
      'device_type': instance.device_type,
      'pay_type': instance.pay_type,
      'gstAmount': instance.gstAmount,
      'fantasy_type_id': instance.fantasy_type_id,
      'affiliate_commission': instance.affiliate_commission,
      'referral': instance.referral,
      'buildType': instance.buildType,
      'myIp': instance.myIp,
      'androidId': instance.androidId,
      'from_user_id': instance.from_user_id,
      'deposit_id': instance.deposit_id,
      'is_skiped_update': instance.is_skiped_update,
      'is_skiped_popup': instance.is_skiped_popup,
      'is_playstore_build': instance.is_playstore_build,
      'teamid': instance.teamid,
    };

NormalRequest _$NormalRequestFromJson(Map<String, dynamic> json) =>
    NormalRequest(
      user_id: json['user_id'] as String?,
      amount: json['amount'] as String?,
      payment_type: json['payment_type'] as String?,
      affiliate_commission: json['affiliate_commission'] as String?,
      build_type: json['build_type'] as String?,
    );

Map<String, dynamic> _$NormalRequestToJson(NormalRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'payment_type': instance.payment_type,
      'amount': instance.amount,
      'affiliate_commission': instance.affiliate_commission,
      'build_type': instance.build_type,
    };

BankInstantRequest _$BankInstantRequestFromJson(Map<String, dynamic> json) =>
    BankInstantRequest(
      user_id: json['user_id'] as String?,
      withdraw_request_id: json['withdraw_request_id'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$BankInstantRequestToJson(BankInstantRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'withdraw_request_id': instance.withdraw_request_id,
      'status': instance.status,
    };
