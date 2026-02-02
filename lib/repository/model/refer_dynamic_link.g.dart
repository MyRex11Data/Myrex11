// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refer_dynamic_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferDynamicLink _$ReferDynamicLinkFromJson(Map<String, dynamic> json) =>
    ReferDynamicLink(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ReferData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReferDynamicLinkToJson(ReferDynamicLink instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ReferData _$ReferDataFromJson(Map<String, dynamic> json) => ReferData(
      shortLink: json['shortLink'] as String?,
      refer_msg: json['refer_msg'] as String?,
    );

Map<String, dynamic> _$ReferDataToJson(ReferData instance) => <String, dynamic>{
      'shortLink': instance.shortLink,
      'refer_msg': instance.refer_msg,
    };
