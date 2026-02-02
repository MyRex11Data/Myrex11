import 'package:json_annotation/json_annotation.dart';
part 'promote_app_request.g.dart';

@JsonSerializable()
class ChannelDetailModel{
  String? name;
  String? url;
  String? type;


  ChannelDetailModel({this.name, this.url, this.type});

  factory ChannelDetailModel.fromJson(Map<String, dynamic> json) => _$ChannelDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelDetailModelToJson(this);
}

@JsonSerializable()
class PromoteAppRequest{
  String? user_id;
  String? name;
  String? email;
  String? mobile;
  String? state;
  String? city;
  List<ChannelDetailModel>? channel_details;


  PromoteAppRequest({this.user_id, this.name, this.email, this.mobile,
      this.state, this.city, this.channel_details});

  factory PromoteAppRequest.fromJson(Map<String, dynamic> json) => _$PromoteAppRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PromoteAppRequestToJson(this);

}