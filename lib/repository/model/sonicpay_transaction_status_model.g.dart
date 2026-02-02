// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonicpay_transaction_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SonicPayTransactionResponse _$SonicPayTransactionResponseFromJson(
        Map<String, dynamic> json) =>
    SonicPayTransactionResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : SonicPayTransactionData.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SonicPayTransactionResponseToJson(
        SonicPayTransactionResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

SonicPayTransactionData _$SonicPayTransactionDataFromJson(
        Map<String, dynamic> json) =>
    SonicPayTransactionData(
      payment_id: json['payment_id'] as String?,
      merchant_email: json['merchant_email'] as String?,
      merchant_id: json['merchant_id'] as String?,
      status: json['status'] as String?,
      status_flag: (json['status_flag'] as num?)?.toInt(),
      payment_mode: json['payment_mode'] as String?,
      order: json['order'] == null
          ? null
          : Order.fromJson(json['order'] as Map<String, dynamic>),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      shipping: json['shipping'] == null
          ? null
          : Shipping.fromJson(json['shipping'] as Map<String, dynamic>),
      billing: json['billing'] == null
          ? null
          : Shipping.fromJson(json['billing'] as Map<String, dynamic>),
      custom_field_1: json['custom_field_1'] as String?,
      custom_field_2: json['custom_field_2'] as String?,
      custom_field_3: json['custom_field_3'] as String?,
      custom_field_4: json['custom_field_4'] as String?,
      custom_field_5: json['custom_field_5'] as String?,
      date: json['date'] as String?,
      signature: json['signature'] as String?,
    );

Map<String, dynamic> _$SonicPayTransactionDataToJson(
        SonicPayTransactionData instance) =>
    <String, dynamic>{
      'payment_id': instance.payment_id,
      'merchant_email': instance.merchant_email,
      'merchant_id': instance.merchant_id,
      'status': instance.status,
      'status_flag': instance.status_flag,
      'payment_mode': instance.payment_mode,
      'order': instance.order,
      'customer': instance.customer,
      'shipping': instance.shipping,
      'billing': instance.billing,
      'custom_field_1': instance.custom_field_1,
      'custom_field_2': instance.custom_field_2,
      'custom_field_3': instance.custom_field_3,
      'custom_field_4': instance.custom_field_4,
      'custom_field_5': instance.custom_field_5,
      'date': instance.date,
      'signature': instance.signature,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      order_id: json['order_id'],
      product_name: json['product_name'],
      gross_amount: json['gross_amount'],
      gateway_fee: json['gateway_fee'],
      currency: json['currency'],
      tax: json['tax'],
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'order_id': instance.order_id,
      'product_name': instance.product_name,
      'gross_amount': instance.gross_amount,
      'gateway_fee': instance.gateway_fee,
      'currency': instance.currency,
      'tax': instance.tax,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      name: json['name'] as String?,
      email_id: json['email_id'] as String?,
      mobile_no: json['mobile_no'] as String?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'name': instance.name,
      'email_id': instance.email_id,
      'mobile_no': instance.mobile_no,
    };

Shipping _$ShippingFromJson(Map<String, dynamic> json) => Shipping(
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      pincode: json['pincode'] as String?,
    );

Map<String, dynamic> _$ShippingToJson(Shipping instance) => <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'pincode': instance.pincode,
    };
