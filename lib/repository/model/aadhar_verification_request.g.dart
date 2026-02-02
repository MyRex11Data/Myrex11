// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aadhar_verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AadharVerificationRequest _$AadharVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    AadharVerificationRequest(
      front_image: json['front_image'] as String?,
      back_image: json['back_image'] as String?,
      user_id: json['user_id'] as String?,
      adhar_number: json['adhar_number'] as String?,
      user_name: json['user_name'] as String?,
    );

Map<String, dynamic> _$AadharVerificationRequestToJson(
        AadharVerificationRequest instance) =>
    <String, dynamic>{
      'front_image': instance.front_image,
      'back_image': instance.back_image,
      'adhar_number': instance.adhar_number,
      'user_id': instance.user_id,
      'user_name': instance.user_name,
    };

AddressVerificationRequest _$AddressVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    AddressVerificationRequest(
      user_id: json['user_id'] as String?,
      document_type: json['document_type'] as String?,
      document_id: json['document_id'] as String?,
    );

Map<String, dynamic> _$AddressVerificationRequestToJson(
        AddressVerificationRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'document_type': instance.document_type,
      'document_id': instance.document_id,
    };
