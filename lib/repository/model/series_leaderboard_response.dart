import 'package:json_annotation/json_annotation.dart';
part 'series_leaderboard_response.g.dart';

@JsonSerializable()
class WinningBreakupDataModel{
  var price;
  var position;
  var gadgets_image;
  var is_gadgets;
  var gadgets_name;

  WinningBreakupDataModel({this.price, this.position,this.gadgets_image,this.is_gadgets,this.gadgets_name});

  factory WinningBreakupDataModel.fromJson(Map<String, dynamic> json) => _$WinningBreakupDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$WinningBreakupDataModelToJson(this);
}
@JsonSerializable()
class SeriesLeaderboardDataModel{
  var id;
  var user_id;
  var series_id;
  var points;
  var rank;
  var status;
  String? team;
  String? image;
  int? promoter_leaderboard_id;

  SeriesLeaderboardDataModel({
      this.id,
      this.user_id,
      this.series_id,
      this.points,
      this.rank,
      this.status,
      this.team,
      this.image,
      this.promoter_leaderboard_id});

  factory SeriesLeaderboardDataModel.fromJson(Map<String, dynamic> json) => _$SeriesLeaderboardDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesLeaderboardDataModelToJson(this);
}
@JsonSerializable()
class SeriesLeaderbardData{
  List<SeriesLeaderboardDataModel>? leaderboard;
  List<WinningBreakupDataModel>? wining_breakup;

  SeriesLeaderbardData({this.leaderboard, this.wining_breakup});

  factory SeriesLeaderbardData.fromJson(Map<String, dynamic> json) => _$SeriesLeaderbardDataFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesLeaderbardDataToJson(this);
}

@JsonSerializable()
class SeriesLeaderboardResponse{
  int? status;
  String? message;
  int? total_pages;
  SeriesLeaderbardData? result;

  SeriesLeaderboardResponse({this.status, this.message,this.total_pages, this.result});

  factory SeriesLeaderboardResponse.fromJson(Map<String, dynamic> json) => _$SeriesLeaderboardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesLeaderboardResponseToJson(this);

}