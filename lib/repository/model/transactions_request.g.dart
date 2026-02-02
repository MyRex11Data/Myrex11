// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionRequest _$TransactionRequestFromJson(Map<String, dynamic> json) =>
    TransactionRequest(
      user_id: json['user_id'] as String?,
      end_date: json['end_date'] as String?,
      start_date: json['start_date'] as String?,
      filter_type: json['filter_type'] as String?,
      status: json['status'] as String?,
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionRequestToJson(TransactionRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'end_date': instance.end_date,
      'start_date': instance.start_date,
      'filter_type': instance.filter_type,
      'status': instance.status,
      'page': instance.page,
    };
