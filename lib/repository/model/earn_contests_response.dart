import 'package:json_annotation/json_annotation.dart';
part 'earn_contests_response.g.dart';

@JsonSerializable()
class EarnContestItem{
  int? win_amount;
  int? maximum_user;
  int? entryfee;
  int? joined;
  dynamic bonus_used;
  String? earned;
  dynamic challenge_id;


  EarnContestItem({this.win_amount, this.maximum_user, this.entryfee,
      this.joined, this.bonus_used, this.earned, this.challenge_id});

  factory EarnContestItem.fromJson(Map<String, dynamic> json) => _$EarnContestItemFromJson(json);
  Map<String, dynamic> toJson() => _$EarnContestItemToJson(this);
}
@JsonSerializable()
class EarnContestTotal{
  dynamic joined;
  dynamic total_contest;
  dynamic earned;


  EarnContestTotal({this.joined, this.total_contest, this.earned});

  factory EarnContestTotal.fromJson(Map<String, dynamic> json) => _$EarnContestTotalFromJson(json);
  Map<String, dynamic> toJson() => _$EarnContestTotalToJson(this);
}
@JsonSerializable()
class EarnContestResult{
  EarnContestTotal? total;
  List<EarnContestItem>? contests;


  EarnContestResult({this.total, this.contests});

  factory EarnContestResult.fromJson(Map<String, dynamic> json) => _$EarnContestResultFromJson(json);
  Map<String, dynamic> toJson() => _$EarnContestResultToJson(this);
}

@JsonSerializable()
class EarnContestResponse{
  int? status;
  String? message;
  EarnContestResult? result;

  EarnContestResponse({this.status, this.message, this.result});

  factory EarnContestResponse.fromJson(Map<String, dynamic> json) => _$EarnContestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EarnContestResponseToJson(this);

}