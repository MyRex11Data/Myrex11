import 'package:json_annotation/json_annotation.dart';
import 'package:myrex11/repository/model/category_contest_response.dart';
part 'create_private_contest_response.g.dart';

@JsonSerializable()
class PrivateContestItemResponse{
  int? challengeid;
  int? status;
  Contest? contest;

  PrivateContestItemResponse({this.challengeid, this.status,this.contest});

  factory PrivateContestItemResponse.fromJson(Map<String, dynamic> json) => _$PrivateContestItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PrivateContestItemResponseToJson(this);

}
@JsonSerializable()
class CreatePrivateContestResponse{
  int? status;
  String? message;
  List<PrivateContestItemResponse>? result;

  CreatePrivateContestResponse({this.status, this.message,this.result});

  factory CreatePrivateContestResponse.fromJson(Map<String, dynamic> json) => _$CreatePrivateContestResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePrivateContestResponseToJson(this);

}