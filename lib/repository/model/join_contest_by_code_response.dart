import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
part 'join_contest_by_code_response.g.dart';

@JsonSerializable()
class JoinContestByCodeItem{
  String? message;
  Contest? contest;

  JoinContestByCodeItem({this.message, this.contest});

  factory JoinContestByCodeItem.fromJson(Map<String, dynamic> json) => _$JoinContestByCodeItemFromJson(json);
  Map<String, dynamic> toJson() => _$JoinContestByCodeItemToJson(this);
}

@JsonSerializable()
class JoinContestByCodeResponse{
  int? status;
  String? message;
  List<JoinContestByCodeItem>? result;

  JoinContestByCodeResponse({this.status, this.message, this.result});

  factory JoinContestByCodeResponse.fromJson(Map<String, dynamic> json) => _$JoinContestByCodeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JoinContestByCodeResponseToJson(this);

}