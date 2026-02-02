import 'package:json_annotation/json_annotation.dart';
part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  String? username;
  String? refer_code;
  String? email;
  String? fcmToken;
  String? deviceId;
  String? password;
  String? password_confirmation;
  String? mobile;
  String? dob;
  String? device_type;
  String? teamname;

  RegisterRequest(
      {this.username,
      this.refer_code,
      this.email,
      this.fcmToken,
      this.deviceId,
      this.password,
      this.password_confirmation,
      this.mobile,
      this.dob,
      this.device_type,
      this.teamname});

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
