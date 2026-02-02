import 'package:json_annotation/json_annotation.dart';
part 'transactions_response.g.dart';

@JsonSerializable()
class TransactionItem {
  String? deduct_amount;
  String? transaction_id;
  String? date;
  String? amount;
  String? transaction_by;
  String? created;
  String? available;
  String? transaction_type;
  String? challengename;
  String? tour;
  String? matchname;
  String? add_amount;
  String? paymentstatus;
  String? teamname;
  String? username;
  int? id;

  TransactionItem(
      {this.deduct_amount,
      this.transaction_id,
      this.date,
      this.amount,
      this.transaction_by,
      this.created,
      this.available,
      this.transaction_type,
      this.challengename,
      this.tour,
      this.matchname,
      this.add_amount,
      this.paymentstatus,
      this.teamname,
      this.username,
      this.id});

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}

@JsonSerializable()
class TransactionHistoryItem {
  int? per_page;
  int? total;
  int? current_page;
  List<TransactionItem>? data;

  TransactionHistoryItem(
      {this.per_page, this.total, this.current_page, this.data});

  factory TransactionHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionHistoryItemToJson(this);
}

@JsonSerializable()
class TransactionsResponse {
  int? status;
  String? message;
  TransactionHistoryItem? result;

  TransactionsResponse({this.status, this.message, this.result});

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionsResponseToJson(this);
}

@JsonSerializable()
class WithdrawTnxResponse {
  int? status;
  String? message;
  WithdrawTnxHistoryItem? result;

  WithdrawTnxResponse({this.status, this.message, this.result});

  factory WithdrawTnxResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawTnxResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawTnxResponseToJson(this);
}

@JsonSerializable()
class WithdrawTnxHistoryItem {
  int? per_page;
  int? total;
  int? current_page;
  List<WithdrawDataItem>? data;

  WithdrawTnxHistoryItem(
      {this.per_page, this.total, this.current_page, this.data});

  factory WithdrawTnxHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$WithdrawTnxHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawTnxHistoryItemToJson(this);
}

@JsonSerializable()
class WithdrawDataItem {
  String? withdraw_request_id;
  String? amount;
  String? created;
  String? status;

  WithdrawDataItem({
    this.withdraw_request_id,
    this.amount,
    this.created,
    this.status,
  });

  factory WithdrawDataItem.fromJson(Map<String, dynamic> json) =>
      _$WithdrawDataItemFromJson(json);
  Map<String, dynamic> toJson() => _$WithdrawDataItemToJson(this);
}
