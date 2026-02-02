// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBalanceResultItem _$MyBalanceResultItemFromJson(Map<String, dynamic> json) =>
    MyBalanceResultItem(
      total: json['total'] as String?,
      balance: json['balance'] as String?,
      winning: json['winning'] as String?,
      totalamount: json['totalamount'] as String?,
      expireamount: (json['expireamount'] as num?)?.toInt(),
      total_match_play: (json['total_match_play'] as num?)?.toInt(),
      bonus: json['bonus'] as String?,
      total_league_play: (json['total_league_play'] as num?)?.toInt(),
      total_winning: json['total_winning'] as String?,
      total_contest_win: (json['total_contest_win'] as num?)?.toInt(),
      email_verify: (json['email_verify'] as num?)?.toInt(),
      bank_verify: (json['bank_verify'] as num?)?.toInt(),
      mobile_verify: (json['mobile_verify'] as num?)?.toInt(),
      pan_verify: (json['pan_verify'] as num?)?.toInt(),
      aadhar_verify: (json['aadhar_verify'] as num?)?.toInt(),
      upi_verify: (json['upi_verify'] as num?)?.toInt(),
      is_withdraw: json['is_withdraw'] as String?,
      is_inst_withdraw: json['is_inst_withdraw'] as String?,
      is_promotor_withdraw: json['is_promotor_withdraw'] as String?,
      is_promotor_inst_withdraw: json['is_promotor_inst_withdraw'] as String?,
      kyc_deposit_check: json['kyc_deposit_check'] as String?,
      kyc_deposit_limit: json['kyc_deposit_limit'] as String?,
      total_cashfree_deposit: json['total_cashfree_deposit'] as String?,
      kyc_deposit_msg: json['kyc_deposit_msg'] as String?,
      level: (json['level'] as num?)?.toInt(),
      Both_earn: json['Both_earn'] as String?,
      Refer_code: json['Refer_code'] as String?,
      refer_statement: json['refer_statement'] as String?,
      signup_refer_statement: json['signup_refer_statement'] as String?,
      lifetime_commission: json['lifetime_commission'] as String?,
      Both_earn_stmt: json['Both_earn_stmt'] as String?,
      is_lifetime_commission: json['is_lifetime_commission'] as String?,
      lifetime_commission_stmt: json['lifetime_commission_stmt'] as String?,
      withdraw_limit_string: json['withdraw_limit_string'] as String?,
      withdraw_min_limit: json['withdraw_min_limit'],
      withdraw_max_limit: json['withdraw_max_limit'],
      commentry_focus: json['commentry_focus'] as String?,
      score_card_focus: json['score_card_focus'] as String?,
      score_focus: json['score_focus'] as String?,
      kyc_verified: (json['kyc_verified'] as num?)?.toInt(),
      for_play_store: json['for_play_store'] as bool?,
      gst_bonus: json['gst_bonus'] as String?,
      affiliate_commission: json['affiliate_commission'],
      refer_affiliate: json['refer_affiliate'] as String?,
      transfer_benifit: json['transfer_benifit'] as String?,
      transfer_benifit_text: json['transfer_benifit_text'] as String?,
      transfer_text: json['transfer_text'] as String?,
      transfer_text1: json['transfer_text1'] as String?,
      transfer_text2: json['transfer_text2'] as String?,
      transfer_text3: json['transfer_text3'] as String?,
      transfer_benifit_percent: json['transfer_benifit_percent'] as String?,
      show_admin_upi: json['show_admin_upi'] as String?,
      admin_upi_list: (json['admin_upi_list'] as List<dynamic>?)
          ?.map((e) => UPIList.fromJson(e as Map<String, dynamic>))
          .toList(),
      show_admin_bank: json['show_admin_bank'] as String?,
      admin_bank_name: json['admin_bank_name'] as String?,
      admin_bank_ifsc: json['admin_bank_ifsc'] as String?,
      admin_bank_customer_name: json['admin_bank_customer_name'] as String?,
      admin_bank_account: json['admin_bank_account'] as String?,
      show_web_payment: json['show_web_payment'] as String?,
    );

Map<String, dynamic> _$MyBalanceResultItemToJson(
        MyBalanceResultItem instance) =>
    <String, dynamic>{
      'total': instance.total,
      'balance': instance.balance,
      'winning': instance.winning,
      'totalamount': instance.totalamount,
      'expireamount': instance.expireamount,
      'total_match_play': instance.total_match_play,
      'bonus': instance.bonus,
      'total_league_play': instance.total_league_play,
      'total_winning': instance.total_winning,
      'total_contest_win': instance.total_contest_win,
      'email_verify': instance.email_verify,
      'bank_verify': instance.bank_verify,
      'mobile_verify': instance.mobile_verify,
      'pan_verify': instance.pan_verify,
      'aadhar_verify': instance.aadhar_verify,
      'upi_verify': instance.upi_verify,
      'is_withdraw': instance.is_withdraw,
      'is_inst_withdraw': instance.is_inst_withdraw,
      'is_promotor_withdraw': instance.is_promotor_withdraw,
      'is_promotor_inst_withdraw': instance.is_promotor_inst_withdraw,
      'kyc_deposit_check': instance.kyc_deposit_check,
      'kyc_deposit_limit': instance.kyc_deposit_limit,
      'total_cashfree_deposit': instance.total_cashfree_deposit,
      'kyc_deposit_msg': instance.kyc_deposit_msg,
      'level': instance.level,
      'signup_refer_statement': instance.signup_refer_statement,
      'refer_statement': instance.refer_statement,
      'Refer_code': instance.Refer_code,
      'Both_earn': instance.Both_earn,
      'lifetime_commission': instance.lifetime_commission,
      'Both_earn_stmt': instance.Both_earn_stmt,
      'lifetime_commission_stmt': instance.lifetime_commission_stmt,
      'is_lifetime_commission': instance.is_lifetime_commission,
      'withdraw_limit_string': instance.withdraw_limit_string,
      'withdraw_min_limit': instance.withdraw_min_limit,
      'withdraw_max_limit': instance.withdraw_max_limit,
      'score_focus': instance.score_focus,
      'commentry_focus': instance.commentry_focus,
      'score_card_focus': instance.score_card_focus,
      'gst_bonus': instance.gst_bonus,
      'refer_affiliate': instance.refer_affiliate,
      'kyc_verified': instance.kyc_verified,
      'affiliate_commission': instance.affiliate_commission,
      'for_play_store': instance.for_play_store,
      'transfer_benifit': instance.transfer_benifit,
      'transfer_benifit_text': instance.transfer_benifit_text,
      'transfer_text': instance.transfer_text,
      'transfer_text1': instance.transfer_text1,
      'transfer_text2': instance.transfer_text2,
      'transfer_text3': instance.transfer_text3,
      'transfer_benifit_percent': instance.transfer_benifit_percent,
      'show_admin_upi': instance.show_admin_upi,
      'admin_upi_list': instance.admin_upi_list,
      'show_admin_bank': instance.show_admin_bank,
      'admin_bank_name': instance.admin_bank_name,
      'admin_bank_ifsc': instance.admin_bank_ifsc,
      'admin_bank_customer_name': instance.admin_bank_customer_name,
      'admin_bank_account': instance.admin_bank_account,
      'show_web_payment': instance.show_web_payment,
    };

MyBalanceResponse _$MyBalanceResponseFromJson(Map<String, dynamic> json) =>
    MyBalanceResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => MyBalanceResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyBalanceResponseToJson(MyBalanceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

UPIList _$UPIListFromJson(Map<String, dynamic> json) => UPIList(
      id: (json['id'] as num?)?.toInt(),
      upi_name: json['upi_name'] as String?,
      upi_number: json['upi_number'] as String?,
      Text: json['Text'] as String?,
      scanner_image: json['scanner_image'] as String?,
    );

Map<String, dynamic> _$UPIListToJson(UPIList instance) => <String, dynamic>{
      'id': instance.id,
      'upi_name': instance.upi_name,
      'upi_number': instance.upi_number,
      'Text': instance.Text,
      'scanner_image': instance.scanner_image,
    };
