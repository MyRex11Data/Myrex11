import 'package:json_annotation/json_annotation.dart';
part 'verify_response.g.dart';

@JsonSerializable()
class AllVerifyItem {
  int? email_verify;
  int? pan_verify;
  int? bank_verify;
  int? upi_verify;
  int? mobile_verify;
  int? aadhar_verify;
  int? address_verify;
  PanData? pan_data;
  BankData? bank_data;
  String? bank_comment;
  String? pan_comment;
  String? aadhar_comment;
  String? upi_comment;
  String? upi_id;
  String? address_type;
  String? address_id;
  AadharData? aadhar_data;

  AllVerifyItem(
      {this.email_verify,
      this.pan_verify,
      this.bank_verify,
      this.upi_verify,
      this.mobile_verify,
      this.aadhar_verify,
      this.address_verify,
      this.pan_data,
      this.bank_data,
      this.bank_comment,
      this.upi_comment,
      this.upi_id,
      this.address_type,
      this.address_id,
      this.pan_comment});

  factory AllVerifyItem.fromJson(Map<String, dynamic> json) =>
      _$AllVerifyItemFromJson(json);
  Map<String, dynamic> toJson() => _$AllVerifyItemToJson(this);
}

@JsonSerializable()
class PanData {
  String? pan_holder_name;
  String? pan_number;
  String? pan_dob;
  String? pan_image;

  PanData(
      {this.pan_holder_name, this.pan_number, this.pan_dob, this.pan_image});
  factory PanData.fromJson(Map<String, dynamic> json) =>
      _$PanDataFromJson(json);
  Map<String, dynamic> toJson() => _$PanDataToJson(this);
}

@JsonSerializable()
class BankData {
  String? account_number;
  String? ifsc;
  String? bankname;
  String? bank_branch;
  String? state;
  String? bank_image;
  String? comment;

  BankData(
      {this.account_number,
      this.ifsc,
      this.bankname,
      this.bank_branch,
      this.state,
      this.bank_image,
      this.comment});
  factory BankData.fromJson(Map<String, dynamic> json) =>
      _$BankDataFromJson(json);
  Map<String, dynamic> toJson() => _$BankDataToJson(this);
}

@JsonSerializable()
class AadharData {
  String? front_image;
  String? back_image;
  String? adhar_number;
  String? user_name;
  String? comment;

  AadharData(
      {this.adhar_number,
      this.front_image,
      this.back_image,
      this.user_name,
      this.comment});
  factory AadharData.fromJson(Map<String, dynamic> json) =>
      _$AadharDataFromJson(json);
  Map<String, dynamic> toJson() => _$AadharDataToJson(this);
}

@JsonSerializable()
class AllVerifyResponse {
  int? status;
  String? message;
  AllVerifyItem? result;

  AllVerifyResponse({this.status, this.message, this.result});

  factory AllVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$AllVerifyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AllVerifyResponseToJson(this);
}
