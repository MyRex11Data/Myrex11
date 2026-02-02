import 'package:json_annotation/json_annotation.dart';
part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  String? email;
  String? password;
  String? deviceId;
  String? fcmToken;
  String? type;
  String? social_id;
  String? name;
  String? image;
  String? idToken;
  String? socialLoginType;
  String? otp;

  LoginRequest(
      {this.email,
      this.password,
      this.deviceId,
      this.fcmToken,
      this.type,
      this.social_id,
      this.name,
      this.image,
      this.idToken,
      this.socialLoginType,
      this.otp});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class NewLoginRequest {
  String? mobile;
  String? otp;
  String? user_id;
  int? new_user;
  String? fcmToken;
  String? teamname;
  String? refer_code;
  String? email;
  String? country;

  NewLoginRequest(
      {this.mobile,
      this.otp,
      this.user_id,
      this.new_user,
      this.fcmToken,
      this.refer_code,
      this.teamname,
      this.email,
      this.country});

  factory NewLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$NewLoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$NewLoginRequestToJson(this);
}
