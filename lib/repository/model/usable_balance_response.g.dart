// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usable_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsableBalanceItem _$UsableBalanceItemFromJson(Map<String, dynamic> json) =>
    UsableBalanceItem(
      usablebalance: json['usablebalance'],
      usertotalbalance: json['usertotalbalance'],
      marathon: (json['marathon'] as num?)?.toDouble(),
      is_bonus: (json['is_bonus'] as num?)?.toInt(),
      is_free_for_referrer: (json['is_free_for_referrer'] as num?)?.toInt(),
      is_gstbonus: json['is_gstbonus'],
      discount_amount: json['discount_amount'],
      total_entry_fee: json['total_entry_fee'],
      to_pay_amount: json['to_pay_amount'],
      total_team: (json['total_team'] as num?)?.toInt(),
      entry_fees: json['entry_fees'],
      to_pay: json['to_pay'],
      entry_fee_real_balance: json['entry_fee_real_balance'] as String?,
      entry_fee_stmt: json['entry_fee_stmt'] as String?,
      Usable_cash_bonus_stmt: json['Usable_cash_bonus_stmt'] as String?,
      Usable_cash_bonus_amount: json['Usable_cash_bonus_amount'] as String?,
      to_pay_stmt: json['to_pay_stmt'] as String?,
      terms_text: json['terms_text'] as String?,
      uti_balance_stmt: json['uti_balance_stmt'] as String?,
      total_entry_fee_text: json['total_entry_fee_text'] as String?,
      total_team_text: json['total_team_text'] as String?,
      discount_amount_text: json['discount_amount_text'] as String?,
      wallet_bonus: json['wallet_bonus'] as String?,
      wallet_gstbonus: json['wallet_gstbonus'] as String?,
    );

Map<String, dynamic> _$UsableBalanceItemToJson(UsableBalanceItem instance) =>
    <String, dynamic>{
      'usablebalance': instance.usablebalance,
      'usertotalbalance': instance.usertotalbalance,
      'marathon': instance.marathon,
      'is_bonus': instance.is_bonus,
      'is_free_for_referrer': instance.is_free_for_referrer,
      'entry_fees': instance.entry_fees,
      'to_pay': instance.to_pay,
      'is_gstbonus': instance.is_gstbonus,
      'discount_amount': instance.discount_amount,
      'total_entry_fee': instance.total_entry_fee,
      'to_pay_amount': instance.to_pay_amount,
      'total_team': instance.total_team,
      'entry_fee_real_balance': instance.entry_fee_real_balance,
      'Usable_cash_bonus_stmt': instance.Usable_cash_bonus_stmt,
      'Usable_cash_bonus_amount': instance.Usable_cash_bonus_amount,
      'to_pay_stmt': instance.to_pay_stmt,
      'terms_text': instance.terms_text,
      'total_team_text': instance.total_team_text,
      'total_entry_fee_text': instance.total_entry_fee_text,
      'discount_amount_text': instance.discount_amount_text,
      'uti_balance_stmt': instance.uti_balance_stmt,
      'entry_fee_stmt': instance.entry_fee_stmt,
      'wallet_bonus': instance.wallet_bonus,
      'wallet_gstbonus': instance.wallet_gstbonus,
    };

BalanceResponse _$BalanceResponseFromJson(Map<String, dynamic> json) =>
    BalanceResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => UsableBalanceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      new_challenge_id: (json['new_challenge_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BalanceResponseToJson(BalanceResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
      'new_challenge_id': instance.new_challenge_id,
    };
