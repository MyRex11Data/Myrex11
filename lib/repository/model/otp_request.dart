
import 'package:json_annotation/json_annotation.dart';
part 'otp_request.g.dart';
@JsonSerializable()
class OtpRequest {
  late String otp;
  late String mobile;
  late String user_id;
  late String type;
  late String email;
  late String fcmToken;


  OtpRequest(this.otp, this.mobile, this.user_id, this.type, this.email,
      this.fcmToken);

  factory OtpRequest.fromJson(Map<String, dynamic> json) => _$OtpRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);
}

