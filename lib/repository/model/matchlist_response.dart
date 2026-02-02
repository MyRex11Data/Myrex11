import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/banner_response.dart';
part 'matchlist_response.g.dart';

@JsonSerializable()
class MatchListResponse {
  int? status;
  int? total_page;
  int? total_live_match;
  String? message;
  SeriesListResponse? result_series;
  List<MatchDetails>? result;
  List<MatchDetails>? users_matches;

  MatchListResponse(
      {this.status,
      this.total_page,
      this.total_live_match,
      this.message,
      this.result_series,
      this.result,
      this.users_matches}); // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory MatchListResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MatchListResponseToJson(this);
}

@JsonSerializable()
class SeriesListResponse {
  int? id;
  int? is_series_leaderboard;
  String? name;
  List<MatchDetails>? matches;

  SeriesListResponse(
      {this.id,
      this.is_series_leaderboard,
      this.name,
      this.matches}); // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory SeriesListResponse.fromJson(Map<String, dynamic> json) =>
      _$SeriesListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesListResponseToJson(this);
}
