import 'package:json_annotation/json_annotation.dart';
part 'sonic_pay_model.g.dart';

@JsonSerializable()

class SonicPayRequest {
  String? sonicpe_ref_id;
  String? order_id;
  String? user_id;
  String? transaction_id;
  String? device_type;
  String? pay_type;
  SonicPayRequest(
      {
        this.sonicpe_ref_id,
        this.order_id,
        this.user_id,
        this.transaction_id,
        this.device_type,
        this.pay_type
      });

  Map<String, dynamic> toJson() => _$SonicPayRequestToJson(this);

}
