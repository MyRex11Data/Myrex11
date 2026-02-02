import 'package:json_annotation/json_annotation.dart';
part 'sonic_pay_process_model.g.dart';

@JsonSerializable()

class SonicPayProcessResponse {
  int? status;
  String? message;
  SonicPayResultData? data;

  SonicPayProcessResponse({this.status, this.message, this.data});

  factory SonicPayProcessResponse.fromJson(Map<String, dynamic> json) => _$SonicPayProcessResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SonicPayProcessResponseToJson(this);
}

@JsonSerializable()
class SonicPayResultData {
  String? transaction_id;
  bool? require_redirect;
  String? redirect_url;
  String? redirect_method;
  String? user_id;

  SonicPayResultData(
      {this.transaction_id,
        this.require_redirect,
        this.redirect_url,
        this.redirect_method,
        this.user_id});

  factory SonicPayResultData.fromJson(Map<String, dynamic> json) => _$SonicPayResultDataFromJson(json);
  Map<String, dynamic> toJson() => _$SonicPayResultDataToJson(this);

}
