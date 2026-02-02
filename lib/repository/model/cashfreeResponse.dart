import 'package:json_annotation/json_annotation.dart';
part 'cashfreeResponse.g.dart';

@JsonSerializable()
class CashFreeResult {
  String? payment_url;
  allData? all_data;
  CashFreeResult({this.payment_url, this.all_data});

  factory CashFreeResult.fromJson(Map<String, dynamic> json) =>
      _$CashFreeResultFromJson(json);
  Map<String, dynamic> toJson() => _$CashFreeResultToJson(this);
}

@JsonSerializable()
class cashfreeResponse {
  int? status;
  String? message;
  CashFreeResult? result;

  cashfreeResponse({this.status, this.message, this.result});

  factory cashfreeResponse.fromJson(Map<String, dynamic> json) =>
      _$cashfreeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$cashfreeResponseToJson(this);
}

@JsonSerializable()
class allData {
  String? payment_session_id;
  String? cf_order_id;
  String? order_id;
  ordermeta? order_meta;

  allData(
      {this.payment_session_id,
      this.cf_order_id,
      this.order_id,
      this.order_meta});

  factory allData.fromJson(Map<String, dynamic> json) =>
      _$allDataFromJson(json);
  Map<String, dynamic> toJson() => _$allDataToJson(this);
}

@JsonSerializable()
class ordermeta {
  String? notify_url;
  String? return_url;

  ordermeta({
    this.notify_url,
    this.return_url,
  });

  factory ordermeta.fromJson(Map<String, dynamic> json) =>
      _$ordermetaFromJson(json);
  Map<String, dynamic> toJson() => _$ordermetaToJson(this);
}

@JsonSerializable()
class PayKuberAllData {
  String? order_id;
  String? txn_id;
  String? status;
  int? amount;
  String? qr_string;
  String? qr_code;
  String? paymentLink;

  PayKuberAllData({
    this.order_id,
    this.txn_id,
    this.status,
    this.amount,
    this.qr_string,
    this.qr_code,
    this.paymentLink,
  });

  factory PayKuberAllData.fromJson(Map<String, dynamic> json) =>
      _$PayKuberAllDataFromJson(json);
  Map<String, dynamic> toJson() => _$PayKuberAllDataToJson(this);
}

@JsonSerializable()
class PayKuberResponse {
  String? status;
  String? message;
  PayKuberAllData? data;

  PayKuberResponse({this.status, this.message, this.data});

  factory PayKuberResponse.fromJson(Map<String, dynamic> json) =>
      _$PayKuberResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PayKuberResponseToJson(this);
}
