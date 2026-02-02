import 'package:json_annotation/json_annotation.dart';
part 'image_upload_response.g.dart';

@JsonSerializable()
class ImageUploadResponseItem{
  String? image;
  int? status;

  ImageUploadResponseItem({this.image, this.status});

  factory ImageUploadResponseItem.fromJson(Map<String, dynamic> json) => _$ImageUploadResponseItemFromJson(json);
  Map<String, dynamic> toJson() => _$ImageUploadResponseItemToJson(this);
}

@JsonSerializable()
class ImageUploadResponse{
  int? status;
  String? message;
  List<ImageUploadResponseItem>? result;

  ImageUploadResponse({this.status, this.message, this.result});

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) => _$ImageUploadResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ImageUploadResponseToJson(this);

}