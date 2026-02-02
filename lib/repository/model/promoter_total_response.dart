import 'package:json_annotation/json_annotation.dart';
part 'promoter_total_response.g.dart';

@JsonSerializable()
class PromoterTotalResult{
  String? winning;
  String? deposit;
  String? aff_bal;
  String? matches;
  String? team_join;
  String? total_referal;
  String? total_earning;
  String? aff_per;
  String? affiliation_tds;


  PromoterTotalResult({this.winning, this.deposit, this.aff_bal, this.matches, this.team_join,this.aff_per,this.total_earning,this.total_referal,this.affiliation_tds});

  factory PromoterTotalResult.fromJson(Map<String, dynamic> json) => _$PromoterTotalResultFromJson(json);
  Map<String, dynamic> toJson() => _$PromoterTotalResultToJson(this);
}

@JsonSerializable()
class PromoterTotalResponse{
  int? status;
  String? message;
  PromoterTotalResult? result;

  PromoterTotalResponse({this.status, this.message, this.result});

  factory PromoterTotalResponse.fromJson(Map<String, dynamic> json) => _$PromoterTotalResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PromoterTotalResponseToJson(this);

}