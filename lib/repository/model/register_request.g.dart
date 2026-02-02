// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      username: json['username'] as String?,
      refer_code: json['refer_code'] as String?,
      email: json['email'] as String?,
      fcmToken: json['fcmToken'] as String?,
      deviceId: json['deviceId'] as String?,
      password: json['password'] as String?,
      password_confirmation: json['password_confirmation'] as String?,
      mobile: json['mobile'] as String?,
      dob: json['dob'] as String?,
      device_type: json['device_type'] as String?,
      teamname: json['teamname'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'refer_code': instance.refer_code,
      'email': instance.email,
      'fcmToken': instance.fcmToken,
      'deviceId': instance.deviceId,
      'password': instance.password,
      'password_confirmation': instance.password_confirmation,
      'mobile': instance.mobile,
      'dob': instance.dob,
      'device_type': instance.device_type,
      'teamname': instance.teamname,
    };
