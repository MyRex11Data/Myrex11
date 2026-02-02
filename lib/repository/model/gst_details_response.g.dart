// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gst_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GstResponse _$GstResponseFromJson(Map<String, dynamic> json) => GstResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : GstDetailsResponseItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GstResponseToJson(GstResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

GstDetailsResponseItem _$GstDetailsResponseItemFromJson(
        Map<String, dynamic> json) =>
    GstDetailsResponseItem(
      offer_text: json['offer_text'] as String?,
      gst_saving: json['gst_saving'] as String?,
      deposit_amount_text: json['deposit_amount_text'] as String?,
      deposit_amount: json['deposit_amount'] as String?,
      gst_applicable_text: json['gst_applicable_text'] as String?,
      gst_applicable: (json['gst_applicable'] as num?)?.toDouble(),
      gst_applicable_smalltext: json['gst_applicable_smalltext'] as String?,
      real_money_bonus: (json['real_money_bonus'] as num?)?.toDouble(),
      real_money_bonus_text: json['real_money_bonus_text'] as String?,
      real_money_bonus_smalltext: json['real_money_bonus_smalltext'] as String?,
      total_amount_text: json['total_amount_text'] as String?,
      total_amount: (json['total_amount'] as num?)?.toDouble(),
      pay: json['pay'] as String?,
      is_gst_rebate: (json['is_gst_rebate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GstDetailsResponseItemToJson(
        GstDetailsResponseItem instance) =>
    <String, dynamic>{
      'offer_text': instance.offer_text,
      'gst_saving': instance.gst_saving,
      'deposit_amount_text': instance.deposit_amount_text,
      'deposit_amount': instance.deposit_amount,
      'gst_applicable_text': instance.gst_applicable_text,
      'gst_applicable': instance.gst_applicable,
      'gst_applicable_smalltext': instance.gst_applicable_smalltext,
      'real_money_bonus': instance.real_money_bonus,
      'real_money_bonus_text': instance.real_money_bonus_text,
      'real_money_bonus_smalltext': instance.real_money_bonus_smalltext,
      'total_amount_text': instance.total_amount_text,
      'total_amount': instance.total_amount,
      'pay': instance.pay,
      'is_gst_rebate': instance.is_gst_rebate,
    };

WithdrawalConfirmation _$WithdrawalConfirmationFromJson(
        Map<String, dynamic> json) =>
    WithdrawalConfirmation(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : TDSResultPopUp.fromJson(json['result'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$WithdrawalConfirmationToJson(
        WithdrawalConfirmation instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
      'message': instance.message,
    };

TDSResultPopUp _$TDSResultPopUpFromJson(Map<String, dynamic> json) =>
    TDSResultPopUp(
      heading: json['heading'] as String?,
      text: json['text'] as String?,
      withdrawal_amt_text: json['withdrawal_amt_text'] as String?,
      withdrawal_amt: json['withdrawal_amt'] as String?,
      tds_save_text: json['tds_save_text'] as String?,
      tds_amt: json['tds_amt'] as String?,
      is_instant: json['is_instant'] as String?,
      instant_text: json['instant_text'] as String?,
      instant_charges: json['instant_charges'] as String?,
      tds_text: json['tds_text'] as String?,
      tds_charges: json['tds_charges'] as String?,
      tds_rebate_text: json['tds_rebate_text'] as String?,
      tds_rebate: json['tds_rebate'] as String?,
      tds_rebate_small_text: json['tds_rebate_small_text'] as String?,
      total_amt_text: json['total_amt_text'] as String?,
      total_amt: json['total_amt'] as String?,
      is_tds_rebate: json['is_tds_rebate'] as String?,
    );

Map<String, dynamic> _$TDSResultPopUpToJson(TDSResultPopUp instance) =>
    <String, dynamic>{
      'heading': instance.heading,
      'text': instance.text,
      'withdrawal_amt_text': instance.withdrawal_amt_text,
      'withdrawal_amt': instance.withdrawal_amt,
      'tds_save_text': instance.tds_save_text,
      'tds_amt': instance.tds_amt,
      'is_instant': instance.is_instant,
      'instant_text': instance.instant_text,
      'instant_charges': instance.instant_charges,
      'tds_text': instance.tds_text,
      'tds_charges': instance.tds_charges,
      'tds_rebate_text': instance.tds_rebate_text,
      'tds_rebate': instance.tds_rebate,
      'tds_rebate_small_text': instance.tds_rebate_small_text,
      'total_amt_text': instance.total_amt_text,
      'total_amt': instance.total_amt,
      'is_tds_rebate': instance.is_tds_rebate,
    };
