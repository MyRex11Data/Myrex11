// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankDetailItem _$BankDetailItemFromJson(Map<String, dynamic> json) =>
    BankDetailItem(
      image: json['image'] as String?,
      imagetype: json['imagetype'] as String?,
      accno: json['accno'] as String?,
      bankbranch: json['bankbranch'] as String?,
      bankname: json['bankname'] as String?,
      state: json['state'] as String?,
      ifsc: json['ifsc'] as String?,
      ac_holder_name: json['ac_holder_name'] as String?,
      comment: json['comment'] as String?,
      status: (json['status'] as num?)?.toInt(),
      content: json['content'] as String?,
      withdraw_time_limit: json['withdraw_time_limit'] as String?,
      node: (json['node'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BankDetailItemToJson(BankDetailItem instance) =>
    <String, dynamic>{
      'image': instance.image,
      'imagetype': instance.imagetype,
      'accno': instance.accno,
      'bankbranch': instance.bankbranch,
      'bankname': instance.bankname,
      'state': instance.state,
      'ifsc': instance.ifsc,
      'ac_holder_name': instance.ac_holder_name,
      'comment': instance.comment,
      'status': instance.status,
      'content': instance.content,
      'withdraw_time_limit': instance.withdraw_time_limit,
      'node': instance.node,
    };

BankDetailResponse _$BankDetailResponseFromJson(Map<String, dynamic> json) =>
    BankDetailResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => BankDetailItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BankDetailResponseToJson(BankDetailResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
