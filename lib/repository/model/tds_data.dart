import 'package:json_annotation/json_annotation.dart';
part 'tds_data.g.dart';

@JsonSerializable()
class GetTDSData {
  int? status;
  Result? result;
  String? message;

  GetTDSData({this.status, this.result,this.message});

  factory GetTDSData.fromJson(Map<String, dynamic> json) => _$GetTDSDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetTDSDataToJson(this);
  }

@JsonSerializable()
class Result {
  dynamic tds_percent;
  dynamic tds_amount;
  dynamic amount;
  dynamic total_amount;

  Result({this.tds_percent, this.tds_amount, this.amount, this.total_amount});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
