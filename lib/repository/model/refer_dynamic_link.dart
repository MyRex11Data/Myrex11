import 'package:json_annotation/json_annotation.dart';
part 'refer_dynamic_link.g.dart';

@JsonSerializable()
class ReferDynamicLink {
  int? status;
  String? message;
  ReferData? data;

  ReferDynamicLink({this.status, this.message, this.data});

  factory ReferDynamicLink.fromJson(Map<String, dynamic> json) =>
      _$ReferDynamicLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ReferDynamicLinkToJson(this);
}

@JsonSerializable()
class ReferData {
  String? shortLink;
  String? refer_msg;

  ReferData({this.shortLink, this.refer_msg});

  factory ReferData.fromJson(Map<String, dynamic> json) =>
      _$ReferDataFromJson(json);
  Map<String, dynamic> toJson() => _$ReferDataToJson(this);
}
