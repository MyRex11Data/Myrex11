// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanVerificationRequest _$PanVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    PanVerificationRequest(
      image: json['image'] as String?,
      pan_number: json['pan_number'] as String?,
      user_id: json['user_id'] as String?,
      state: json['state'] as String?,
      pan_name: json['pan_name'] as String?,
      pan_dob: json['pan_dob'] as String?,
    );

Map<String, dynamic> _$PanVerificationRequestToJson(
        PanVerificationRequest instance) =>
    <String, dynamic>{
      'image': instance.image,
      'pan_number': instance.pan_number,
      'user_id': instance.user_id,
      'state': instance.state,
      'pan_name': instance.pan_name,
      'pan_dob': instance.pan_dob,
    };
