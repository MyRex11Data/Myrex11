// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    NotificationItem(
      created_at: json['created_at'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$NotificationItemToJson(NotificationItem instance) =>
    <String, dynamic>{
      'created_at': instance.created_at,
      'title': instance.title,
    };

GetNotificationResponse _$GetNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    GetNotificationResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetNotificationResponseToJson(
        GetNotificationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
