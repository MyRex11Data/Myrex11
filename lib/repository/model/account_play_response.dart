import 'package:json_annotation/json_annotation.dart';
part 'account_play_response.g.dart';
@JsonSerializable()
class PlayData{
  int? total_match_play;
  int? total_league_play;
  int? total_contest_win;
  String? total_winning;
  PlayData({this.total_contest_win,this.total_league_play,this.total_match_play,this.total_winning,});

  factory PlayData.fromJson(Map<String, dynamic> json) => _$PlayDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlayDataToJson(this);
}

@JsonSerializable()
class PlayDataResponse{
  int? status;
  String? message;
  PlayData? result;


  PlayDataResponse({this.status, this.message,
    this.result}); // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory PlayDataResponse.fromJson(Map<String, dynamic> json) => _$PlayDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PlayDataResponseToJson(this);

}