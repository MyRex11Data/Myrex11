// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadResponseItem _$ImageUploadResponseItemFromJson(
        Map<String, dynamic> json) =>
    ImageUploadResponseItem(
      image: json['image'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ImageUploadResponseItemToJson(
        ImageUploadResponseItem instance) =>
    <String, dynamic>{
      'image': instance.image,
      'status': instance.status,
    };

ImageUploadResponse _$ImageUploadResponseFromJson(Map<String, dynamic> json) =>
    ImageUploadResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) =>
              ImageUploadResponseItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageUploadResponseToJson(
        ImageUploadResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
