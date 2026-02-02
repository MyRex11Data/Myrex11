
import 'package:json_annotation/json_annotation.dart';
part 'get_offer_response.g.dart';
@JsonSerializable()
class GetOfferResponse {
  int? status;
  String? message;
  List<Result>? result;

  GetOfferResponse({this.status, this.message, this.result});

  factory GetOfferResponse.fromJson(Map<String, dynamic> json) => _$GetOfferResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetOfferResponseToJson(this);
}

@JsonSerializable()
class Result {
  String? team;
  int? entryfee;
  String? offer;

  Result({this.team, this.entryfee, this.offer});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}