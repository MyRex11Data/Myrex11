import 'package:json_annotation/json_annotation.dart';
part 'leaderboard_details_response.g.dart';

@JsonSerializable()
class LeaderboardMatchData{
  int? teamid;
  int? challenge_id;
  String? points;
  String? match_name;
  String? match_date;
  String? teamname;
  String? sport_key;


  LeaderboardMatchData({this.teamid, this.challenge_id, this.points,
      this.match_name, this.match_date, this.teamname, this.sport_key});

  factory LeaderboardMatchData.fromJson(Map<String, dynamic> json) => _$LeaderboardMatchDataFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardMatchDataToJson(this);
}

@JsonSerializable()
class LeaderboardDetailsResponse{
  bool? success;
  String? message;
  String? series_date;
  String? series_name;
  String? image;
  String? name;
  var week_number;
  var amount;
  var points;
  var rank;
  List<LeaderboardMatchData>? match_list;


  LeaderboardDetailsResponse({
      this.success,
      this.message,
      this.series_date,
      this.series_name,
      this.image,
      this.name,
      this.week_number,
      this.amount,
      this.points,
      this.rank,
      this.match_list});

  factory LeaderboardDetailsResponse.fromJson(Map<String, dynamic> json) => _$LeaderboardDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LeaderboardDetailsResponseToJson(this);

}