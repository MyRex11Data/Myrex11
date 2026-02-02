// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_verify_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankVerifyResponseItem _$BankVerifyResponseItemFromJson(
        Map<String, dynamic> json) =>
    BankVerifyResponseItem(
      json['msg'] as String?,
      (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BankVerifyResponseItemToJson(
        BankVerifyResponseItem instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'status': instance.status,
    };

BankVerifyResponse _$BankVerifyResponseFromJson(Map<String, dynamic> json) =>
    BankVerifyResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : BankVerifyResponseItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BankVerifyResponseToJson(BankVerifyResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

UpiVerifyResponseItem _$UpiVerifyResponseItemFromJson(
        Map<String, dynamic> json) =>
    UpiVerifyResponseItem(
      json['msg'] as String?,
      (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpiVerifyResponseItemToJson(
        UpiVerifyResponseItem instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'status': instance.status,
    };

UpiVerifyResponse _$UpiVerifyResponseFromJson(Map<String, dynamic> json) =>
    UpiVerifyResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : UpiVerifyResponseItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpiVerifyResponseToJson(UpiVerifyResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
