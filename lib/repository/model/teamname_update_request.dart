import 'package:json_annotation/json_annotation.dart';
part 'teamname_update_request.g.dart';

@JsonSerializable()
class TeamNameUpdateRequest {
  String? user_id;
  String? teamname;
  String? state;
  String? user_refer_code;
  bool? is_state_update;
  String? fcmToken;
  String? myIP;
  String? buildType;
  String? androidId;
  String? versionCode;
  String? myAddress;
  String? ip;

  TeamNameUpdateRequest(
      {this.user_id,
      this.teamname,
      this.state,
      this.user_refer_code,
      this.is_state_update,
      this.fcmToken,
      this.myIP,
      this.androidId,
      this.buildType,
      this.versionCode,
      this.myAddress,
      this.ip});

  factory TeamNameUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$TeamNameUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TeamNameUpdateRequestToJson(this);
}
