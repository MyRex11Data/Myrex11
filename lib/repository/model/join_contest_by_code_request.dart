
import 'package:json_annotation/json_annotation.dart';
part 'join_contest_by_code_request.g.dart';
@JsonSerializable()
class JoinContestByCodeRequest {
  String? user_id;
  String? matchkey;
  String? getcode;
  String? sport_key;
  String? fantasy_type;
  String? slotes_id;


  JoinContestByCodeRequest({this.user_id, this.matchkey, this.getcode,
      this.sport_key, this.fantasy_type, this.slotes_id});

  factory JoinContestByCodeRequest.fromJson(Map<String, dynamic> json) => _$JoinContestByCodeRequestFromJson(json);
  Map<String, dynamic> toJson() => _$JoinContestByCodeRequestToJson(this);
}

