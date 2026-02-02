import 'package:json_annotation/json_annotation.dart';
part 'join_contest_request.g.dart';

@JsonSerializable()
class JoinContestRequest {
  String? matchkey;
  String? user_id;
  String? challengeid;
  String? sport_key;
  String? fantasy_type;
  String? slotes_id;
  String? teamid;
  String? multiple_contest;
  String? fantasy_type_id;
  String? join_similar_count;

  JoinContestRequest(
      {this.matchkey,
      this.user_id,
      this.challengeid,
      this.sport_key,
      this.fantasy_type,
      this.slotes_id,
      this.teamid,
      this.multiple_contest,
      this.fantasy_type_id,
      this.join_similar_count});

  factory JoinContestRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinContestRequestFromJson(json);
  Map<String, dynamic> toJson() => _$JoinContestRequestToJson(this);
}
