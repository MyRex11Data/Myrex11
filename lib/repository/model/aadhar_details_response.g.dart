// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aadhar_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AadharDetailItem _$AadharDetailItemFromJson(Map<String, dynamic> json) =>
    AadharDetailItem(
      front_image: json['front_image'] as String?,
      back_image: json['back_image'] as String?,
      imagetype: json['imagetype'] as String?,
      user_name: json['user_name'] as String?,
      adhar_number: json['adhar_number'] as String?,
      comment: json['comment'] as String?,
      message: json['message'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AadharDetailItemToJson(AadharDetailItem instance) =>
    <String, dynamic>{
      'front_image': instance.front_image,
      'back_image': instance.back_image,
      'imagetype': instance.imagetype,
      'user_name': instance.user_name,
      'adhar_number': instance.adhar_number,
      'comment': instance.comment,
      'message': instance.message,
      'status': instance.status,
    };

AadharDetailsResponse _$AadharDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    AadharDetailsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : AadharDetailItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AadharDetailsResponseToJson(
        AadharDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
