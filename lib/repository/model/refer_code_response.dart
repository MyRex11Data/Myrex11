import 'package:json_annotation/json_annotation.dart';
part 'refer_code_response.g.dart';

@JsonSerializable()
class ReferCodeResponse {
  int? status;
  Result? result;

  ReferCodeResponse({this.status, this.result});


  factory ReferCodeResponse.fromJson(Map<String, dynamic> json) => _$ReferCodeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReferCodeResponseToJson(this);
}
@JsonSerializable()
class Result {
  String? refer_code;

  Result({this.refer_code});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);

}