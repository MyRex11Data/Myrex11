
import 'package:json_annotation/json_annotation.dart';
part 'team_preview_point_request.g.dart';
@JsonSerializable()
class TeamPreviewPointRequest {
  String? user_id;
  String? teamid;
  String? challenge;
  String? sport_key;
  String? fantasy_type;
  String? slotes_id;
  String? fantasy_type_id;


  TeamPreviewPointRequest({this.user_id, this.teamid, this.challenge,
      this.sport_key, this.fantasy_type, this.slotes_id,this.fantasy_type_id});

  factory TeamPreviewPointRequest.fromJson(Map<String, dynamic> json) => _$TeamPreviewPointRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPreviewPointRequestToJson(this);
}

