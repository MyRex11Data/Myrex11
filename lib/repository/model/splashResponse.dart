import 'package:json_annotation/json_annotation.dart';
part 'splashResponse.g.dart';

@JsonSerializable()
class SplashResponse {
  int? status;
  String? message;
  SplashResult? result;
  SplashResponse({this.status, this.result, this.message});

  factory SplashResponse.fromJson(Map<String, dynamic> json) =>
      _$SplashResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SplashResponseToJson(this);
}

@JsonSerializable()
class SplashResult {
  int? id;
  String? title;
  String? link;
  String? image;
  String? get_refer_code_via_ip;

  SplashResult(
      {this.id, this.title, this.link, this.image, this.get_refer_code_via_ip});
  factory SplashResult.fromJson(Map<String, dynamic> json) =>
      _$SplashResultFromJson(json);
  Map<String, dynamic> toJson() => _$SplashResultToJson(this);
}

@JsonSerializable()
class UpiDetailsResponse {
  int? status;
  String? message;
  // SplashResult? result;
  UpiDetailsResponse({this.status, this.message});

  factory UpiDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$UpiDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpiDetailsResponseToJson(this);
}

// @JsonSerializable()
// class SplashResult {
//   int? id;
//   String? title;
//   String? link;
//   String? image;
//   String? get_refer_code_via_ip;

//   SplashResult(
//       {this.id, this.title, this.link, this.image, this.get_refer_code_via_ip});
//   factory SplashResult.fromJson(Map<String, dynamic> json) =>
//       _$SplashResultFromJson(json);
//   Map<String, dynamic> toJson() => _$SplashResultToJson(this);
// }
