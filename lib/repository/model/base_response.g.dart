// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralResponse _$GeneralResponseFromJson(Map<String, dynamic> json) =>
    GeneralResponse(
      status: json['status'],
      promo_id: (json['promo_id'] as num?)?.toInt(),
      message: json['message'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$GeneralResponseToJson(GeneralResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'promo_id': instance.promo_id,
      'message': instance.message,
      'amount': instance.amount,
      'token': instance.token,
    };
