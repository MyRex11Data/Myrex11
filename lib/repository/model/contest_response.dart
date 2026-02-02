import 'package:json_annotation/json_annotation.dart';

import 'category_contest_response.dart';
part 'contest_response.g.dart';

@JsonSerializable()
class ContestData{
  int? user_teams;
  int? joined_leagues;
  List<Contest>? contest;

  ContestData({this.user_teams, this.joined_leagues,
      this.contest});

  // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory ContestData.fromJson(Map<String, dynamic> json) => _$ContestDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContestDataToJson(this);

}
@JsonSerializable()
class ContestResponse{
  int? status;
  String? message;
  ContestData? result;

  ContestResponse({this.status, this.message,
      this.result});

  // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory ContestResponse.fromJson(Map<String, dynamic> json) => _$ContestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ContestResponseToJson(this);

}