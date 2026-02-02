// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      pincode: json['pincode'] as String?,
      address: json['address'] as String?,
      device_id: json['device_id'] as String?,
      gender: json['gender'] as String?,
      city: json['city'] as String?,
      custom_user_token: json['custom_user_token'] as String?,
      mobile: json['mobile'] as String?,
      dob: json['dob'] as String?,
      refercode: json['refercode'] as String?,
      fcmToken: json['fcmToken'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      team: json['team'] as String?,
      state: json['state'] as String?,
      email_verify: (json['email_verify'] as num?)?.toInt(),
      pan_verify: (json['pan_verify'] as num?)?.toInt(),
      bank_verify: (json['bank_verify'] as num?)?.toInt(),
      mobile_verify: (json['mobile_verify'] as num?)?.toInt(),
      user_id: json['user_id'] as String?,
      new_user: (json['new_user'] as num?)?.toInt(),
      user_profile_image: json['user_profile_image'] as String?,
      aadhar_verify: (json['aadhar_verify'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'new_user': instance.new_user,
      'pincode': instance.pincode,
      'address': instance.address,
      'device_id': instance.device_id,
      'gender': instance.gender,
      'city': instance.city,
      'custom_user_token': instance.custom_user_token,
      'mobile': instance.mobile,
      'dob': instance.dob,
      'refercode': instance.refercode,
      'fcmToken': instance.fcmToken,
      'email': instance.email,
      'username': instance.username,
      'team': instance.team,
      'state': instance.state,
      'user_profile_image': instance.user_profile_image,
      'email_verify': instance.email_verify,
      'pan_verify': instance.pan_verify,
      'bank_verify': instance.bank_verify,
      'mobile_verify': instance.mobile_verify,
      'aadhar_verify': instance.aadhar_verify,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      status: (json['status'] as num?)?.toInt(),
      isMobile: (json['isMobile'] as num?)?.toInt(),
      number: json['number'],
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : LoginData.fromJson(json['result'] as Map<String, dynamic>),
      is_register: (json['is_register'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'isMobile': instance.isMobile,
      'number': instance.number,
      'message': instance.message,
      'result': instance.result,
      'is_register': instance.is_register,
    };
