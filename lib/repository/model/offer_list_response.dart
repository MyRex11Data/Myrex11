import 'package:json_annotation/json_annotation.dart';
part 'offer_list_response.g.dart';

@JsonSerializable()
class OfferListDataModel{
  int? id;
  String? code;
  String? expire_date;
  String? description;
  String? title;

  OfferListDataModel({
      this.id, this.code, this.expire_date, this.description, this.title});

  factory OfferListDataModel.fromJson(Map<String, dynamic> json) => _$OfferListDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$OfferListDataModelToJson(this);
}

@JsonSerializable()
class OfferResultModel{
  List<OfferListDataModel>? data;

  OfferResultModel({this.data});

  factory OfferResultModel.fromJson(Map<String, dynamic> json) => _$OfferResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$OfferResultModelToJson(this);
}

@JsonSerializable()
class OfferListResponse{
  int? status;
  String? message;
  OfferResultModel? result;

  OfferListResponse({this.status, this.message, this.result});

  factory OfferListResponse.fromJson(Map<String, dynamic> json) => _$OfferListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OfferListResponseToJson(this);

}