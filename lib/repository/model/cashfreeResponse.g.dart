// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashfreeResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashFreeResult _$CashFreeResultFromJson(Map<String, dynamic> json) =>
    CashFreeResult(
      payment_url: json['payment_url'] as String?,
      all_data: json['all_data'] == null
          ? null
          : allData.fromJson(json['all_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CashFreeResultToJson(CashFreeResult instance) =>
    <String, dynamic>{
      'payment_url': instance.payment_url,
      'all_data': instance.all_data,
    };

cashfreeResponse _$cashfreeResponseFromJson(Map<String, dynamic> json) =>
    cashfreeResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : CashFreeResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$cashfreeResponseToJson(cashfreeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

allData _$allDataFromJson(Map<String, dynamic> json) => allData(
      payment_session_id: json['payment_session_id'] as String?,
      cf_order_id: json['cf_order_id'] as String?,
      order_id: json['order_id'] as String?,
      order_meta: json['order_meta'] == null
          ? null
          : ordermeta.fromJson(json['order_meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$allDataToJson(allData instance) => <String, dynamic>{
      'payment_session_id': instance.payment_session_id,
      'cf_order_id': instance.cf_order_id,
      'order_id': instance.order_id,
      'order_meta': instance.order_meta,
    };

ordermeta _$ordermetaFromJson(Map<String, dynamic> json) => ordermeta(
      notify_url: json['notify_url'] as String?,
      return_url: json['return_url'] as String?,
    );

Map<String, dynamic> _$ordermetaToJson(ordermeta instance) => <String, dynamic>{
      'notify_url': instance.notify_url,
      'return_url': instance.return_url,
    };

PayKuberAllData _$PayKuberAllDataFromJson(Map<String, dynamic> json) =>
    PayKuberAllData(
      order_id: json['order_id'] as String?,
      txn_id: json['txn_id'] as String?,
      status: json['status'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      qr_string: json['qr_string'] as String?,
      qr_code: json['qr_code'] as String?,
      paymentLink: json['paymentLink'] as String?,
    );

Map<String, dynamic> _$PayKuberAllDataToJson(PayKuberAllData instance) =>
    <String, dynamic>{
      'order_id': instance.order_id,
      'txn_id': instance.txn_id,
      'status': instance.status,
      'amount': instance.amount,
      'qr_string': instance.qr_string,
      'qr_code': instance.qr_code,
      'paymentLink': instance.paymentLink,
    };

PayKuberResponse _$PayKuberResponseFromJson(Map<String, dynamic> json) =>
    PayKuberResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : PayKuberAllData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PayKuberResponseToJson(PayKuberResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
