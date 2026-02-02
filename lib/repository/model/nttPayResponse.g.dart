// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nttPayResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NttResult _$NttResultFromJson(Map<String, dynamic> json) => NttResult(
      userId: json['userId'] as String?,
      login: json['login'] as String?,
      password: json['password'] as String?,
      prodid: json['prodid'] as String?,
      requestHashKey: json['requestHashKey'] as String?,
      responseHashKey: json['responseHashKey'] as String?,
      requestEncryptionKey: json['requestEncryptionKey'] as String?,
      responseDecryptionKey: json['responseDecryptionKey'] as String?,
      txnid: json['txnid'] as String?,
      clientcode: json['clientcode'] as String?,
      txncurr: json['txncurr'] as String?,
      mccCode: json['mccCode'] as String?,
      merchType: json['merchType'] as String?,
      amount: json['amount'] as String?,
      mode: json['mode'] as String?,
      custFirstName: json['custFirstName'] as String?,
      custLastName: json['custLastName'] as String?,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      custacc: json['custacc'] as String?,
      udf1: json['udf1'] as String?,
      udf2: json['udf2'] as String?,
      udf3: json['udf3'] as String?,
      udf4: json['udf4'] as String?,
      udf5: json['udf5'] as String?,
      authApiUrl: json['authApiUrl'] as String?,
      returnUrl: json['returnUrl'] as String?,
      payment_url: json['payment_url'] as String?,
    );

Map<String, dynamic> _$NttResultToJson(NttResult instance) => <String, dynamic>{
      'userId': instance.userId,
      'login': instance.login,
      'password': instance.password,
      'prodid': instance.prodid,
      'requestHashKey': instance.requestHashKey,
      'responseHashKey': instance.responseHashKey,
      'requestEncryptionKey': instance.requestEncryptionKey,
      'responseDecryptionKey': instance.responseDecryptionKey,
      'txnid': instance.txnid,
      'clientcode': instance.clientcode,
      'txncurr': instance.txncurr,
      'mccCode': instance.mccCode,
      'merchType': instance.merchType,
      'amount': instance.amount,
      'mode': instance.mode,
      'custFirstName': instance.custFirstName,
      'custLastName': instance.custLastName,
      'mobile': instance.mobile,
      'email': instance.email,
      'address': instance.address,
      'custacc': instance.custacc,
      'udf1': instance.udf1,
      'udf2': instance.udf2,
      'udf3': instance.udf3,
      'udf4': instance.udf4,
      'udf5': instance.udf5,
      'authApiUrl': instance.authApiUrl,
      'returnUrl': instance.returnUrl,
      'payment_url': instance.payment_url,
    };

NttPayResponse _$NttPayResponseFromJson(Map<String, dynamic> json) =>
    NttPayResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : NttResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NttPayResponseToJson(NttPayResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
