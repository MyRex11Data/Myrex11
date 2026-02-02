// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpRequest _$OtpRequestFromJson(Map<String, dynamic> json) => OtpRequest(
      json['otp'] as String,
      json['mobile'] as String,
      json['user_id'] as String,
      json['type'] as String,
      json['email'] as String,
      json['fcmToken'] as String,
    );

Map<String, dynamic> _$OtpRequestToJson(OtpRequest instance) =>
    <String, dynamic>{
      'otp': instance.otp,
      'mobile': instance.mobile,
      'user_id': instance.user_id,
      'type': instance.type,
      'email': instance.email,
      'fcmToken': instance.fcmToken,
    };
