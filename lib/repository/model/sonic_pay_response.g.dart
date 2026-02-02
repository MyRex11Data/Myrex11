// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonic_pay_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SonicPayCreate _$SonicPayCreateFromJson(Map<String, dynamic> json) =>
    SonicPayCreate(
      status: (json['status'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : SonicPayCreateData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SonicPayCreateToJson(SonicPayCreate instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'message': instance.message,
    };

SonicPayCreateData _$SonicPayCreateDataFromJson(Map<String, dynamic> json) =>
    SonicPayCreateData(
      sonicpe_ref_id: json['sonicpe_ref_id'] as String?,
      order_id: json['order_id'] as String?,
      user_id: json['user_id'] as String?,
      device_type: json['device_type'] as String?,
      pay_type: json['pay_type'] as String?,
    );

Map<String, dynamic> _$SonicPayCreateDataToJson(SonicPayCreateData instance) =>
    <String, dynamic>{
      'sonicpe_ref_id': instance.sonicpe_ref_id,
      'order_id': instance.order_id,
      'user_id': instance.user_id,
      'device_type': instance.device_type,
      'pay_type': instance.pay_type,
    };
