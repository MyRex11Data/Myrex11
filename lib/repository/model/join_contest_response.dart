import 'package:json_annotation/json_annotation.dart';
part 'join_contest_response.g.dart';

@JsonSerializable()
class JoinItem{
  bool? status;
  String? join_message;
  String? refercode;
  int? isjoined;


  JoinItem({this.status, this.join_message, this.refercode, this.isjoined});

  factory JoinItem.fromJson(Map<String, dynamic> json) => _$JoinItemFromJson(json);
  Map<String, dynamic> toJson() => _$JoinItemToJson(this);
}

@JsonSerializable()
class JoinContestResponse{
  int? status;
  int? new_challenge_id;
  String? message;
  List<JoinItem>? result;

  JoinContestResponse({this.status,this.new_challenge_id, this.message, this.result});

  factory JoinContestResponse.fromJson(Map<String, dynamic> json) => _$JoinContestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JoinContestResponseToJson(this);

}