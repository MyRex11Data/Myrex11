
import 'package:json_annotation/json_annotation.dart';
part 'create_private_contest_request.g.dart';
@JsonSerializable()
class WinnerBreakUpData {
  String? rank;
  String? winningPer;
  String? winningAmmount;

  WinnerBreakUpData({this.rank, this.winningPer, this.winningAmmount});

  factory WinnerBreakUpData.fromJson(Map<String, dynamic> json) => _$WinnerBreakUpDataFromJson(json);
  Map<String, dynamic> toJson() => _$WinnerBreakUpDataToJson(this);
}
@JsonSerializable()
class CreatePrivateContestRequest {
  String? entryfee;
  String? matchkey;
  String? name;
  String? is_public;
  String? multi_entry;
  String? win_amount;
  String? user_id;
  String? maximum_user;
  String? sport_key;
  String? fantasy_type;
  String? slotes_id;
  String? fantasy_type_id;
  List<WinnerBreakUpData>? pricecards;


  CreatePrivateContestRequest({
      this.entryfee,
      this.matchkey,
      this.name,
      this.is_public,
      this.multi_entry,
      this.win_amount,
      this.user_id,
      this.maximum_user,
      this.sport_key,
      this.fantasy_type,
      this.slotes_id,
      this.pricecards,
  this.fantasy_type_id});

  factory CreatePrivateContestRequest.fromJson(Map<String, dynamic> json) => _$CreatePrivateContestRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePrivateContestRequestToJson(this);
}

