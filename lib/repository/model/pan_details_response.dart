import 'package:json_annotation/json_annotation.dart';
part 'pan_details_response.g.dart';

@JsonSerializable()
class PanDetailItem{
  String? image;
  String? imagetype;
  String? pandob;
  String? panname;
  String? pannumber;
  String? comment;
  String? message;
  int? status;

  PanDetailItem({this.image, this.imagetype, this.pandob, this.panname,
      this.pannumber, this.comment, this.message, this.status});

  factory PanDetailItem.fromJson(Map<String, dynamic> json) => _$PanDetailItemFromJson(json);
  Map<String, dynamic> toJson() => _$PanDetailItemToJson(this);
}

@JsonSerializable()
class PanDetailsResponse{
  int? status;
  String? message;
  PanDetailItem? result;

  PanDetailsResponse({this.status, this.message, this.result});

  factory PanDetailsResponse.fromJson(Map<String, dynamic> json) => _$PanDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PanDetailsResponseToJson(this);

}