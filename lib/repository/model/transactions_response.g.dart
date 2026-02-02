// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      deduct_amount: json['deduct_amount'] as String?,
      transaction_id: json['transaction_id'] as String?,
      date: json['date'] as String?,
      amount: json['amount'] as String?,
      transaction_by: json['transaction_by'] as String?,
      created: json['created'] as String?,
      available: json['available'] as String?,
      transaction_type: json['transaction_type'] as String?,
      challengename: json['challengename'] as String?,
      tour: json['tour'] as String?,
      matchname: json['matchname'] as String?,
      add_amount: json['add_amount'] as String?,
      paymentstatus: json['paymentstatus'] as String?,
      teamname: json['teamname'] as String?,
      username: json['username'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'deduct_amount': instance.deduct_amount,
      'transaction_id': instance.transaction_id,
      'date': instance.date,
      'amount': instance.amount,
      'transaction_by': instance.transaction_by,
      'created': instance.created,
      'available': instance.available,
      'transaction_type': instance.transaction_type,
      'challengename': instance.challengename,
      'tour': instance.tour,
      'matchname': instance.matchname,
      'add_amount': instance.add_amount,
      'paymentstatus': instance.paymentstatus,
      'teamname': instance.teamname,
      'username': instance.username,
      'id': instance.id,
    };

TransactionHistoryItem _$TransactionHistoryItemFromJson(
        Map<String, dynamic> json) =>
    TransactionHistoryItem(
      per_page: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      current_page: (json['current_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionHistoryItemToJson(
        TransactionHistoryItem instance) =>
    <String, dynamic>{
      'per_page': instance.per_page,
      'total': instance.total,
      'current_page': instance.current_page,
      'data': instance.data,
    };

TransactionsResponse _$TransactionsResponseFromJson(
        Map<String, dynamic> json) =>
    TransactionsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : TransactionHistoryItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionsResponseToJson(
        TransactionsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

WithdrawTnxResponse _$WithdrawTnxResponseFromJson(Map<String, dynamic> json) =>
    WithdrawTnxResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : WithdrawTnxHistoryItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WithdrawTnxResponseToJson(
        WithdrawTnxResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

WithdrawTnxHistoryItem _$WithdrawTnxHistoryItemFromJson(
        Map<String, dynamic> json) =>
    WithdrawTnxHistoryItem(
      per_page: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      current_page: (json['current_page'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WithdrawDataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WithdrawTnxHistoryItemToJson(
        WithdrawTnxHistoryItem instance) =>
    <String, dynamic>{
      'per_page': instance.per_page,
      'total': instance.total,
      'current_page': instance.current_page,
      'data': instance.data,
    };

WithdrawDataItem _$WithdrawDataItemFromJson(Map<String, dynamic> json) =>
    WithdrawDataItem(
      withdraw_request_id: json['withdraw_request_id'] as String?,
      amount: json['amount'] as String?,
      created: json['created'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$WithdrawDataItemToJson(WithdrawDataItem instance) =>
    <String, dynamic>{
      'withdraw_request_id': instance.withdraw_request_id,
      'amount': instance.amount,
      'created': instance.created,
      'status': instance.status,
    };
