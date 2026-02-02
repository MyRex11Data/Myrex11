import 'package:json_annotation/json_annotation.dart';
part 'withdraw_amount_response.g.dart';

@JsonSerializable()
class WithdrawItem {
  String? msg;
  double? amount;
  double? wining;
  int? status;
  String? withdraw_request_id;

  WithdrawItem(
      {this.msg,
      this.amount,
      this.wining,
      this.status,
      this.withdraw_request_id});

  factory WithdrawItem.fromJson(Map<String, dynamic> json) =>
      _$WithdrawItemFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawItemToJson(this);
}

@JsonSerializable()
class WithdrawResponse {
  int? status;
  String? message;
  WithdrawItem? result;

  WithdrawResponse({this.status, this.message, this.result});

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawResponseToJson(this);
}

@JsonSerializable()
class CheckWithdrawResponse {
  int? status;
  String? message;
  ProcessItem? result;

  CheckWithdrawResponse({this.status, this.message, this.result});

  factory CheckWithdrawResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckWithdrawResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CheckWithdrawResponseToJson(this);
}

@JsonSerializable()
class ProcessItem {
  String? msg;
  String? status;

  ProcessItem({
    this.msg,
    this.status,
  });

  factory ProcessItem.fromJson(Map<String, dynamic> json) =>
      _$ProcessItemFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessItemToJson(this);
}
