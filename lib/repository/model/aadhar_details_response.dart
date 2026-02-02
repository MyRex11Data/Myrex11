import 'package:json_annotation/json_annotation.dart';
part 'aadhar_details_response.g.dart';

@JsonSerializable()
class AadharDetailItem {
  String? front_image;
  String? back_image;
  String? imagetype;
  String? user_name;
  String? adhar_number;
  String? comment;
  String? message;
  int? status;

  AadharDetailItem(
      {this.front_image,
      this.back_image,
      this.imagetype,
      this.user_name,
      this.adhar_number,
      this.comment,
      this.message,
      this.status});

  factory AadharDetailItem.fromJson(Map<String, dynamic> json) =>
      _$AadharDetailItemFromJson(json);
  Map<String, dynamic> toJson() => _$AadharDetailItemToJson(this);
}

@JsonSerializable()
class AadharDetailsResponse {
  int? status;
  String? message;
  AadharDetailItem? result;

  AadharDetailsResponse({this.status, this.message, this.result});

  factory AadharDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$AadharDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AadharDetailsResponseToJson(this);
}
