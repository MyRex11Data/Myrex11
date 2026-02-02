import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class LoginData {
  String? user_id;
  int? new_user;
  String? pincode;
  String? address;
  String? device_id;
  String? gender;
  String? city;
  String? custom_user_token;
  String? mobile;
  String? dob;
  String? refercode;
  String? fcmToken;
  String? email;
  String? username;
  String? team;
  String? state;
  String? user_profile_image;
  int? email_verify;
  int? pan_verify;
  int? bank_verify;
  int? mobile_verify;
  int? aadhar_verify;

  LoginData(
      {this.pincode,
      this.address,
      this.device_id,
      this.gender,
      this.city,
      this.custom_user_token,
      this.mobile,
      this.dob,
      this.refercode,
      this.fcmToken,
      this.email,
      this.username,
      this.team,
      this.state,
      this.email_verify,
      this.pan_verify,
      this.bank_verify,
      this.mobile_verify,
      this.user_id,
      this.new_user,
      this.user_profile_image,
      this.aadhar_verify}); //

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginResponse {
  int? status;
  int? isMobile;
  var number;

  String? message;
  LoginData? result;
  int? is_register;

  LoginResponse(
      {this.status, this.isMobile, this.number, this.message, this.result,this.is_register});

// LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
