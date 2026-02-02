import 'package:json_annotation/json_annotation.dart';
part "aadhar_verification_request.g.dart";

@JsonSerializable()
class AadharVerificationRequest {
  String? front_image;
  String? back_image;
  String? adhar_number;
  String? user_id;
  String? user_name;

  AadharVerificationRequest(
      {this.front_image,
      this.back_image,
      this.user_id,
      this.adhar_number,
      this.user_name});

  factory AadharVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$AadharVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AadharVerificationRequestToJson(this);
}

@JsonSerializable()
class AddressVerificationRequest {
  String? user_id;
  String? document_type;
  String? document_id;

  AddressVerificationRequest(
      {this.user_id, this.document_type, this.document_id});

  factory AddressVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$AddressVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AddressVerificationRequestToJson(this);
}
