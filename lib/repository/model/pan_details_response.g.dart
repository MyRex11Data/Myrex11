// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanDetailItem _$PanDetailItemFromJson(Map<String, dynamic> json) =>
    PanDetailItem(
      image: json['image'] as String?,
      imagetype: json['imagetype'] as String?,
      pandob: json['pandob'] as String?,
      panname: json['panname'] as String?,
      pannumber: json['pannumber'] as String?,
      comment: json['comment'] as String?,
      message: json['message'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PanDetailItemToJson(PanDetailItem instance) =>
    <String, dynamic>{
      'image': instance.image,
      'imagetype': instance.imagetype,
      'pandob': instance.pandob,
      'panname': instance.panname,
      'pannumber': instance.pannumber,
      'comment': instance.comment,
      'message': instance.message,
      'status': instance.status,
    };

PanDetailsResponse _$PanDetailsResponseFromJson(Map<String, dynamic> json) =>
    PanDetailsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : PanDetailItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PanDetailsResponseToJson(PanDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
