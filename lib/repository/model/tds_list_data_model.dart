import 'package:json_annotation/json_annotation.dart';
part 'tds_list_data_model.g.dart';


@JsonSerializable()
class TdsListData {
  int? status;
  Result? result;

  TdsListData({this.status, this.result});

  factory TdsListData.fromJson(Map<String, dynamic> json) => _$TdsListDataFromJson(json);
  Map<String, dynamic> toJson() => _$TdsListDataToJson(this);

}

@JsonSerializable()
class Result {
  List<TrasactionList>? trasaction_list;

  Result({this.trasaction_list});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class TrasactionList {
  String? text;
  String? tds_date;
  String? tds_amount;

  TrasactionList({this.text, this.tds_date, this.tds_amount});

  factory TrasactionList.fromJson(Map<String, dynamic> json) => _$TrasactionListFromJson(json);
  Map<String, dynamic> toJson() => _$TrasactionListToJson(this);
}
