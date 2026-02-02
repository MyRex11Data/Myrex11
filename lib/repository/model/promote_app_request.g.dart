// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promote_app_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelDetailModel _$ChannelDetailModelFromJson(Map<String, dynamic> json) =>
    ChannelDetailModel(
      name: json['name'] as String?,
      url: json['url'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ChannelDetailModelToJson(ChannelDetailModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'type': instance.type,
    };

PromoteAppRequest _$PromoteAppRequestFromJson(Map<String, dynamic> json) =>
    PromoteAppRequest(
      user_id: json['user_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      channel_details: (json['channel_details'] as List<dynamic>?)
          ?.map((e) => ChannelDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromoteAppRequestToJson(PromoteAppRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'state': instance.state,
      'city': instance.city,
      'channel_details': instance.channel_details,
    };
