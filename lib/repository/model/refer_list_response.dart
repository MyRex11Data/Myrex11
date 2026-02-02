import 'package:json_annotation/json_annotation.dart';
part 'refer_list_response.g.dart';

@JsonSerializable()
class ReferLIstItem {
  var Amount;
  String? name;
  String? email;
  String? username;
  String? image;
  int? id;

  ReferLIstItem(
      {this.Amount, this.name, this.email, this.username, this.image, this.id});

  factory ReferLIstItem.fromJson(Map<String, dynamic> json) =>
      _$ReferLIstItemFromJson(json);
  Map<String, dynamic> toJson() => _$ReferLIstItemToJson(this);
}

@JsonSerializable()
class ReferBonusListResponse {
  int? status;
  int? total_pages;
  var total_amount;
  int? total_user;
  String? message;
  List<ReferLIstItem>? result;

  ReferBonusListResponse(
      {this.status,
      this.total_pages,
      this.total_amount,
      this.total_user,
      this.message,
      this.result});

  factory ReferBonusListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReferBonusListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReferBonusListResponseToJson(this);
}
