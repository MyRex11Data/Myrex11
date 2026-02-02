import 'package:json_annotation/json_annotation.dart';
part 'nttPayResponse.g.dart';

@JsonSerializable()
class NttResult {
  String? userId;
  String? login;
  String? password;
  String? prodid;
  String? requestHashKey;
  String? responseHashKey;
  String? requestEncryptionKey;
  String? responseDecryptionKey;
  String? txnid;
  String? clientcode;
  String? txncurr;
  String? mccCode;
  String? merchType;
  String? amount;
  String? mode;
  String? custFirstName;
  String? custLastName;
  String? mobile;
  String? email;
  String? address;
  String? custacc;
  String? udf1;
  String? udf2;
  String? udf3;
  String? udf4;
  String? udf5;
  String? authApiUrl;
  String? returnUrl;
  String? payment_url;

  NttResult(
      {this.userId,
      this.login,
      this.password,
      this.prodid,
      this.requestHashKey,
      this.responseHashKey,
      this.requestEncryptionKey,
      this.responseDecryptionKey,
      this.txnid,
      this.clientcode,
      this.txncurr,
      this.mccCode,
      this.merchType,
      this.amount,
      this.mode,
      this.custFirstName,
      this.custLastName,
      this.mobile,
      this.email,
      this.address,
      this.custacc,
      this.udf1,
      this.udf2,
      this.udf3,
      this.udf4,
      this.udf5,
      this.authApiUrl,
      this.returnUrl,
      this.payment_url});

  factory NttResult.fromJson(Map<String, dynamic> json) =>
      _$NttResultFromJson(json);
  Map<String, dynamic> toJson() => _$NttResultToJson(this);
}

@JsonSerializable()
class NttPayResponse {
  int? status;
  String? message;
  NttResult? result;

  NttPayResponse({this.status, this.message, this.result});

  factory NttPayResponse.fromJson(Map<String, dynamic> json) =>
      _$NttPayResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NttPayResponseToJson(this);
}
