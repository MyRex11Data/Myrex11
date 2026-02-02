// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllVerifyItem _$AllVerifyItemFromJson(Map<String, dynamic> json) =>
    AllVerifyItem(
      email_verify: (json['email_verify'] as num?)?.toInt(),
      pan_verify: (json['pan_verify'] as num?)?.toInt(),
      bank_verify: (json['bank_verify'] as num?)?.toInt(),
      upi_verify: (json['upi_verify'] as num?)?.toInt(),
      mobile_verify: (json['mobile_verify'] as num?)?.toInt(),
      aadhar_verify: (json['aadhar_verify'] as num?)?.toInt(),
      address_verify: (json['address_verify'] as num?)?.toInt(),
      pan_data: json['pan_data'] == null
          ? null
          : PanData.fromJson(json['pan_data'] as Map<String, dynamic>),
      bank_data: json['bank_data'] == null
          ? null
          : BankData.fromJson(json['bank_data'] as Map<String, dynamic>),
      bank_comment: json['bank_comment'] as String?,
      upi_comment: json['upi_comment'] as String?,
      upi_id: json['upi_id'] as String?,
      address_type: json['address_type'] as String?,
      address_id: json['address_id'] as String?,
      pan_comment: json['pan_comment'] as String?,
    )
      ..aadhar_comment = json['aadhar_comment'] as String?
      ..aadhar_data = json['aadhar_data'] == null
          ? null
          : AadharData.fromJson(json['aadhar_data'] as Map<String, dynamic>);

Map<String, dynamic> _$AllVerifyItemToJson(AllVerifyItem instance) =>
    <String, dynamic>{
      'email_verify': instance.email_verify,
      'pan_verify': instance.pan_verify,
      'bank_verify': instance.bank_verify,
      'upi_verify': instance.upi_verify,
      'mobile_verify': instance.mobile_verify,
      'aadhar_verify': instance.aadhar_verify,
      'address_verify': instance.address_verify,
      'pan_data': instance.pan_data,
      'bank_data': instance.bank_data,
      'bank_comment': instance.bank_comment,
      'pan_comment': instance.pan_comment,
      'aadhar_comment': instance.aadhar_comment,
      'upi_comment': instance.upi_comment,
      'upi_id': instance.upi_id,
      'address_type': instance.address_type,
      'address_id': instance.address_id,
      'aadhar_data': instance.aadhar_data,
    };

PanData _$PanDataFromJson(Map<String, dynamic> json) => PanData(
      pan_holder_name: json['pan_holder_name'] as String?,
      pan_number: json['pan_number'] as String?,
      pan_dob: json['pan_dob'] as String?,
      pan_image: json['pan_image'] as String?,
    );

Map<String, dynamic> _$PanDataToJson(PanData instance) => <String, dynamic>{
      'pan_holder_name': instance.pan_holder_name,
      'pan_number': instance.pan_number,
      'pan_dob': instance.pan_dob,
      'pan_image': instance.pan_image,
    };

BankData _$BankDataFromJson(Map<String, dynamic> json) => BankData(
      account_number: json['account_number'] as String?,
      ifsc: json['ifsc'] as String?,
      bankname: json['bankname'] as String?,
      bank_branch: json['bank_branch'] as String?,
      state: json['state'] as String?,
      bank_image: json['bank_image'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$BankDataToJson(BankData instance) => <String, dynamic>{
      'account_number': instance.account_number,
      'ifsc': instance.ifsc,
      'bankname': instance.bankname,
      'bank_branch': instance.bank_branch,
      'state': instance.state,
      'bank_image': instance.bank_image,
      'comment': instance.comment,
    };

AadharData _$AadharDataFromJson(Map<String, dynamic> json) => AadharData(
      adhar_number: json['adhar_number'] as String?,
      front_image: json['front_image'] as String?,
      back_image: json['back_image'] as String?,
      user_name: json['user_name'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$AadharDataToJson(AadharData instance) =>
    <String, dynamic>{
      'front_image': instance.front_image,
      'back_image': instance.back_image,
      'adhar_number': instance.adhar_number,
      'user_name': instance.user_name,
      'comment': instance.comment,
    };

AllVerifyResponse _$AllVerifyResponseFromJson(Map<String, dynamic> json) =>
    AllVerifyResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : AllVerifyItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AllVerifyResponseToJson(AllVerifyResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
