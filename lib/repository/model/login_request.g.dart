// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String?,
      password: json['password'] as String?,
      deviceId: json['deviceId'] as String?,
      fcmToken: json['fcmToken'] as String?,
      type: json['type'] as String?,
      social_id: json['social_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      idToken: json['idToken'] as String?,
      socialLoginType: json['socialLoginType'] as String?,
      otp: json['otp'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
      'type': instance.type,
      'social_id': instance.social_id,
      'name': instance.name,
      'image': instance.image,
      'idToken': instance.idToken,
      'socialLoginType': instance.socialLoginType,
      'otp': instance.otp,
    };

NewLoginRequest _$NewLoginRequestFromJson(Map<String, dynamic> json) =>
    NewLoginRequest(
      mobile: json['mobile'] as String?,
      otp: json['otp'] as String?,
      user_id: json['user_id'] as String?,
      new_user: (json['new_user'] as num?)?.toInt(),
      fcmToken: json['fcmToken'] as String?,
      refer_code: json['refer_code'] as String?,
      teamname: json['teamname'] as String?,
      email: json['email'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$NewLoginRequestToJson(NewLoginRequest instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'otp': instance.otp,
      'user_id': instance.user_id,
      'new_user': instance.new_user,
      'fcmToken': instance.fcmToken,
      'teamname': instance.teamname,
      'refer_code': instance.refer_code,
      'email': instance.email,
      'country': instance.country,
    };
