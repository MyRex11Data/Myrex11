import 'package:json_annotation/json_annotation.dart';
part 'tds_model.g.dart';

@JsonSerializable()
class GetTdsData {
  int? status;
  TdsResult? result;

  GetTdsData({this.status, this.result});

  factory GetTdsData.fromJson(Map<String, dynamic> json) => _$GetTdsDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetTdsDataToJson(this);

}
@JsonSerializable()
class TdsResult {
  Tdsdata? tdsdata;
  TdsResult({this.tdsdata});
  factory TdsResult.fromJson(Map<String, dynamic> json) => _$TdsResultFromJson(json);
  Map<String, dynamic> toJson() => _$TdsResultToJson(this);
}
@JsonSerializable()
class Tdsdata {

  String? financial_year;
  String? financial_year_withdraw;
  String? total_investment;
  String? opening_balance;
  String? total_deposit;
  String? total_withdraw;
  dynamic total_commission;
  dynamic total_winning;
  String? tds_to_be_paid;
  String? tds_paid;

  Tdsdata(
      {
        this.financial_year_withdraw,
        this.financial_year,
        this.total_investment,
        this.total_winning,
        this.tds_to_be_paid,
        this.tds_paid,
        this.opening_balance,
        this.total_commission,
        this.total_deposit,
        this.total_withdraw});
  factory Tdsdata.fromJson(Map<String, dynamic> json) => _$TdsdataFromJson(json);
  Map<String, dynamic> toJson() => _$TdsdataToJson(this);
}
