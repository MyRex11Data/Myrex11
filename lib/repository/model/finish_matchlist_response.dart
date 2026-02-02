import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/banner_response.dart';
part 'finish_matchlist_response.g.dart';

@JsonSerializable()
class FinishMatchResult{
  List<MatchDetails>? data;
  int? current_page;
  int? total;
  int? per_page;


  FinishMatchResult({this.data, this.current_page, this.total, this.per_page});

  factory FinishMatchResult.fromJson(Map<String, dynamic> json) => _$FinishMatchResultFromJson(json);
  Map<String, dynamic> toJson() => _$FinishMatchResultToJson(this);
}

@JsonSerializable()
class FinishMatchListResponse{
  int? status;
  int? total_live_match;
  String? message;
  FinishMatchResult? result;

  FinishMatchListResponse({this.status, this.total_live_match, this.message, this.result});

  factory FinishMatchListResponse.fromJson(Map<String, dynamic> json) => _$FinishMatchListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FinishMatchListResponseToJson(this);

}