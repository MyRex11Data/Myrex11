import 'package:json_annotation/json_annotation.dart';
part 'base_response.g.dart';

@JsonSerializable()
class GeneralResponse{
  var status;
  int? promo_id;
  String? message;
  int? amount;
  String? token;


  GeneralResponse({this.status, this.promo_id, this.message, this.amount, this.token}); // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory GeneralResponse.fromJson(Map<String, dynamic> json) => _$GeneralResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);

}