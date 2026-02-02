// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_amount_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawItem _$WithdrawItemFromJson(Map<String, dynamic> json) => WithdrawItem(
      msg: json['msg'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      wining: (json['wining'] as num?)?.toDouble(),
      status: (json['status'] as num?)?.toInt(),
      withdraw_request_id: json['withdraw_request_id'] as String?,
    );

Map<String, dynamic> _$WithdrawItemToJson(WithdrawItem instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'amount': instance.amount,
      'wining': instance.wining,
      'status': instance.status,
      'withdraw_request_id': instance.withdraw_request_id,
    };

WithdrawResponse _$WithdrawResponseFromJson(Map<String, dynamic> json) =>
    WithdrawResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : WithdrawItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WithdrawResponseToJson(WithdrawResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

CheckWithdrawResponse _$CheckWithdrawResponseFromJson(
        Map<String, dynamic> json) =>
    CheckWithdrawResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : ProcessItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckWithdrawResponseToJson(
        CheckWithdrawResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

ProcessItem _$ProcessItemFromJson(Map<String, dynamic> json) => ProcessItem(
      msg: json['msg'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$ProcessItemToJson(ProcessItem instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'status': instance.status,
    };
