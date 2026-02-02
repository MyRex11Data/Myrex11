import 'package:json_annotation/json_annotation.dart';
part 'bank_verify_response.g.dart';

@JsonSerializable()
class BankVerifyResponseItem {
  String? msg;
  int? status;

  BankVerifyResponseItem(this.msg, this.status);

  factory BankVerifyResponseItem.fromJson(Map<String, dynamic> json) =>
      _$BankVerifyResponseItemFromJson(json);
  Map<String, dynamic> toJson() => _$BankVerifyResponseItemToJson(this);
}

@JsonSerializable()
class BankVerifyResponse {
  int? status;
  String? message;
  BankVerifyResponseItem? result;

  BankVerifyResponse({this.status, this.message, this.result});

  factory BankVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$BankVerifyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BankVerifyResponseToJson(this);
}

@JsonSerializable()
class UpiVerifyResponseItem {
  String? msg;
  int? status;

  UpiVerifyResponseItem(this.msg, this.status);

  factory UpiVerifyResponseItem.fromJson(Map<String, dynamic> json) =>
      _$UpiVerifyResponseItemFromJson(json);
  Map<String, dynamic> toJson() => _$UpiVerifyResponseItemToJson(this);
}

@JsonSerializable()
class UpiVerifyResponse {
  int? status;
  String? message;
  UpiVerifyResponseItem? result;

  UpiVerifyResponse({this.status, this.message, this.result});

  factory UpiVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$UpiVerifyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpiVerifyResponseToJson(this);
}
