import 'package:json_annotation/json_annotation.dart';
part 'bank_details_response.g.dart';

@JsonSerializable()
class BankDetailItem {
  String? image;
  String? imagetype;
  String? accno;
  String? bankbranch;
  String? bankname;
  String? state;
  String? ifsc;
  String? ac_holder_name;
  String? comment;
  int? status;
  String? content;
  String? withdraw_time_limit;
  List<String>? node;

  BankDetailItem(
      {this.image,
      this.imagetype,
      this.accno,
      this.bankbranch,
      this.bankname,
      this.state,
      this.ifsc,
      this.ac_holder_name,
      this.comment,
      this.status,
      this.content,
      this.withdraw_time_limit,
      this.node});

  factory BankDetailItem.fromJson(Map<String, dynamic> json) =>
      _$BankDetailItemFromJson(json);
  Map<String, dynamic> toJson() => _$BankDetailItemToJson(this);
}

@JsonSerializable()
class BankDetailResponse {
  int? status;
  String? message;
  List<BankDetailItem>? result;

  BankDetailResponse({this.status, this.message, this.result});

  factory BankDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$BankDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BankDetailResponseToJson(this);
}
