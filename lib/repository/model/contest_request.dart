import 'package:json_annotation/json_annotation.dart';
part 'contest_request.g.dart';

@JsonSerializable()
class ContestRequest {
  String? matchkey;
  String? user_id;
  String? userid;
  String? challenge_id;
  String? page;
  String? category_id;
  String? entryfee;
  String? winning;
  String? contest_type;
  String? contest_size;
  String? sport_key;
  String? fantasy_type;
  String? slotes_id;
  String? teamid;
  String? joinid;
  String? fantasy_type_id;
  int? credittype;
  String? spots;
  int? isEdit;

  ContestRequest(
      {this.credittype,
      this.matchkey,
      this.user_id,
      this.userid,
      this.challenge_id,
      this.page,
      this.category_id,
      this.entryfee,
      this.winning,
      this.contest_type,
      this.contest_size,
      this.sport_key,
      this.fantasy_type,
      this.slotes_id,
      this.teamid,
      this.joinid,
      this.fantasy_type_id,
      this.spots,
      this.isEdit});

  factory ContestRequest.fromJson(Map<String, dynamic> json) =>
      _$ContestRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ContestRequestToJson(this);
}
