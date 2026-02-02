// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonic_pay_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SonicPayRequest _$SonicPayRequestFromJson(Map<String, dynamic> json) =>
    SonicPayRequest(
      sonicpe_ref_id: json['sonicpe_ref_id'] as String?,
      order_id: json['order_id'] as String?,
      user_id: json['user_id'] as String?,
      transaction_id: json['transaction_id'] as String?,
      device_type: json['device_type'] as String?,
      pay_type: json['pay_type'] as String?,
    );

Map<String, dynamic> _$SonicPayRequestToJson(SonicPayRequest instance) =>
    <String, dynamic>{
      'sonicpe_ref_id': instance.sonicpe_ref_id,
      'order_id': instance.order_id,
      'user_id': instance.user_id,
      'transaction_id': instance.transaction_id,
      'device_type': instance.device_type,
      'pay_type': instance.pay_type,
    };
