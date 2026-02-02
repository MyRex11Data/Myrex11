import 'package:json_annotation/json_annotation.dart';
part 'bank_verification_request.g.dart';

@JsonSerializable()
class BankVerifyRequest {
  String? image;
  String? accno;
  String? caccno;
  String? user_id;
  String? bankname;
  String? state;
  String? ifsc;
  String? bankbranch;
  String? ac_holder_name;
  String? upi_id;
  int? is_edit;
  BankVerifyRequest(
      {this.image,
      this.accno,
      this.caccno,
      this.user_id,
      this.bankname,
      this.state,
      this.ifsc,
      this.bankbranch,
      this.ac_holder_name,
      this.upi_id,
      this.is_edit});

  factory BankVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$BankVerifyRequestFromJson(json);
  Map<String, dynamic> toJson() => _$BankVerifyRequestToJson(this);
}
