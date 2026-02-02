// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refer_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferLIstItem _$ReferLIstItemFromJson(Map<String, dynamic> json) =>
    ReferLIstItem(
      Amount: json['Amount'],
      name: json['name'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      image: json['image'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReferLIstItemToJson(ReferLIstItem instance) =>
    <String, dynamic>{
      'Amount': instance.Amount,
      'name': instance.name,
      'email': instance.email,
      'username': instance.username,
      'image': instance.image,
      'id': instance.id,
    };

ReferBonusListResponse _$ReferBonusListResponseFromJson(
        Map<String, dynamic> json) =>
    ReferBonusListResponse(
      status: (json['status'] as num?)?.toInt(),
      total_pages: (json['total_pages'] as num?)?.toInt(),
      total_amount: json['total_amount'],
      total_user: (json['total_user'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => ReferLIstItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReferBonusListResponseToJson(
        ReferBonusListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total_pages': instance.total_pages,
      'total_amount': instance.total_amount,
      'total_user': instance.total_user,
      'message': instance.message,
      'result': instance.result,
    };
