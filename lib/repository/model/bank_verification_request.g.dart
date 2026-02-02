// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankVerifyRequest _$BankVerifyRequestFromJson(Map<String, dynamic> json) =>
    BankVerifyRequest(
      image: json['image'] as String?,
      accno: json['accno'] as String?,
      caccno: json['caccno'] as String?,
      user_id: json['user_id'] as String?,
      bankname: json['bankname'] as String?,
      state: json['state'] as String?,
      ifsc: json['ifsc'] as String?,
      bankbranch: json['bankbranch'] as String?,
      ac_holder_name: json['ac_holder_name'] as String?,
      upi_id: json['upi_id'] as String?,
      is_edit: (json['is_edit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BankVerifyRequestToJson(BankVerifyRequest instance) =>
    <String, dynamic>{
      'image': instance.image,
      'accno': instance.accno,
      'caccno': instance.caccno,
      'user_id': instance.user_id,
      'bankname': instance.bankname,
      'state': instance.state,
      'ifsc': instance.ifsc,
      'bankbranch': instance.bankbranch,
      'ac_holder_name': instance.ac_holder_name,
      'upi_id': instance.upi_id,
      'is_edit': instance.is_edit,
    };
