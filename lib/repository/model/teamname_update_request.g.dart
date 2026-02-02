// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamname_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamNameUpdateRequest _$TeamNameUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    TeamNameUpdateRequest(
      user_id: json['user_id'] as String?,
      teamname: json['teamname'] as String?,
      state: json['state'] as String?,
      user_refer_code: json['user_refer_code'] as String?,
      is_state_update: json['is_state_update'] as bool?,
      fcmToken: json['fcmToken'] as String?,
      myIP: json['myIP'] as String?,
      androidId: json['androidId'] as String?,
      buildType: json['buildType'] as String?,
      versionCode: json['versionCode'] as String?,
      myAddress: json['myAddress'] as String?,
      ip: json['ip'] as String?,
    );

Map<String, dynamic> _$TeamNameUpdateRequestToJson(
        TeamNameUpdateRequest instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'teamname': instance.teamname,
      'state': instance.state,
      'user_refer_code': instance.user_refer_code,
      'is_state_update': instance.is_state_update,
      'fcmToken': instance.fcmToken,
      'myIP': instance.myIP,
      'buildType': instance.buildType,
      'androidId': instance.androidId,
      'versionCode': instance.versionCode,
      'myAddress': instance.myAddress,
      'ip': instance.ip,
    };
