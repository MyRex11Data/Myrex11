// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splashResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SplashResponse _$SplashResponseFromJson(Map<String, dynamic> json) =>
    SplashResponse(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : SplashResult.fromJson(json['result'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$SplashResponseToJson(SplashResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

SplashResult _$SplashResultFromJson(Map<String, dynamic> json) => SplashResult(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      link: json['link'] as String?,
      image: json['image'] as String?,
      get_refer_code_via_ip: json['get_refer_code_via_ip'] as String?,
    );

Map<String, dynamic> _$SplashResultToJson(SplashResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'image': instance.image,
      'get_refer_code_via_ip': instance.get_refer_code_via_ip,
    };

UpiDetailsResponse _$UpiDetailsResponseFromJson(Map<String, dynamic> json) =>
    UpiDetailsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$UpiDetailsResponseToJson(UpiDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
