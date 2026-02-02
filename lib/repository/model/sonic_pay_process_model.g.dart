// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonic_pay_process_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SonicPayProcessResponse _$SonicPayProcessResponseFromJson(
        Map<String, dynamic> json) =>
    SonicPayProcessResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : SonicPayResultData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SonicPayProcessResponseToJson(
        SonicPayProcessResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

SonicPayResultData _$SonicPayResultDataFromJson(Map<String, dynamic> json) =>
    SonicPayResultData(
      transaction_id: json['transaction_id'] as String?,
      require_redirect: json['require_redirect'] as bool?,
      redirect_url: json['redirect_url'] as String?,
      redirect_method: json['redirect_method'] as String?,
      user_id: json['user_id'] as String?,
    );

Map<String, dynamic> _$SonicPayResultDataToJson(SonicPayResultData instance) =>
    <String, dynamic>{
      'transaction_id': instance.transaction_id,
      'require_redirect': instance.require_redirect,
      'redirect_url': instance.redirect_url,
      'redirect_method': instance.redirect_method,
      'user_id': instance.user_id,
    };
