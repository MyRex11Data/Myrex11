
import 'package:json_annotation/json_annotation.dart';
part 'sonicpay_transaction_status_model.g.dart';

@JsonSerializable()
class SonicPayTransactionResponse {
  int? status;
  String? message;
  SonicPayTransactionData? data;

  SonicPayTransactionResponse({this.status, this.message, this.data});

  factory SonicPayTransactionResponse.fromJson(Map<String, dynamic> json) => _$SonicPayTransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SonicPayTransactionResponseToJson(this);


}
@JsonSerializable()
class SonicPayTransactionData {

  String? payment_id;
  String? merchant_email;
  String? merchant_id;
  String? status;
  int? status_flag;
  String? payment_mode;
  Order? order;
  Customer? customer;
  Shipping? shipping;
  Shipping? billing;
  String? custom_field_1;
  String? custom_field_2;
  String? custom_field_3;
  String? custom_field_4;
  String? custom_field_5;
  String? date;
  String? signature;

  SonicPayTransactionData(
      {this.payment_id,
        this.merchant_email,
        this.merchant_id,
        this.status,
        this.status_flag,
        this.payment_mode,
        this.order,
        this.customer,
        this.shipping,
        this.billing,
        this.custom_field_1,
        this.custom_field_2,
        this.custom_field_3,
        this.custom_field_4,
        this.custom_field_5,
        this.date,
        this.signature});

  factory SonicPayTransactionData.fromJson(Map<String, dynamic> json) => _$SonicPayTransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$SonicPayTransactionDataToJson(this);
}
@JsonSerializable()
class Order {
  dynamic order_id;
  dynamic product_name;
  dynamic gross_amount;
  dynamic gateway_fee;
  dynamic currency;
  dynamic tax;

  Order(
      {this.order_id,
        this.product_name,
        this.gross_amount,
        this.gateway_fee,
        this.currency,
        this.tax});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
@JsonSerializable()
class Customer {
  String? name;
  String? email_id;
  String? mobile_no;

  Customer({this.name, this.email_id, this.mobile_no});

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
@JsonSerializable()
class Shipping {
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;

  Shipping({this.address, this.city, this.state, this.country, this.pincode});

  factory Shipping.fromJson(Map<String, dynamic> json) => _$ShippingFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingToJson(this);
}
