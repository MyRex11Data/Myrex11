import 'package:json_annotation/json_annotation.dart';
part 'sonic_pay_response.g.dart';

@JsonSerializable()
class SonicPayCreate {
  int? status;
  SonicPayCreateData? data;
  String? message;

  SonicPayCreate({this.status, this.data,this.message});

  factory SonicPayCreate.fromJson(Map<String, dynamic> json) => _$SonicPayCreateFromJson(json);
  Map<String, dynamic> toJson() => _$SonicPayCreateToJson(this);

}
@JsonSerializable()
class SonicPayCreateData {
  String? sonicpe_ref_id;
  String? order_id;
  String? user_id;
  String? device_type;
  String? pay_type;
  SonicPayCreateData({this.sonicpe_ref_id,this.order_id,this.user_id,this.device_type,this.pay_type});
  factory SonicPayCreateData.fromJson(Map<String, dynamic> json) => _$SonicPayCreateDataFromJson(json);
  Map<String, dynamic> toJson() => _$SonicPayCreateDataToJson(this);
}
