import 'package:json_annotation/json_annotation.dart';
part 'pan_verification_request.g.dart';

@JsonSerializable()
class PanVerificationRequest{
  String? image;
  String? pan_number;
  String? user_id;
  String? state;
  String? pan_name;
  String? pan_dob;


  PanVerificationRequest({this.image, this.pan_number, this.user_id, this.state,
      this.pan_name, this.pan_dob});

  factory PanVerificationRequest.fromJson(Map<String, dynamic> json) => _$PanVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PanVerificationRequestToJson(this);
}
