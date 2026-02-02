import 'package:json_annotation/json_annotation.dart';
part 'score_card_response.g.dart';

@JsonSerializable()
class WinnerScoreCardItem {
  int? winners;
  int? id;
  String? start_position;
  double? total;
  double? price;
  String? description;
  int? is_gadget;
  String? gadget_image;
  String? gadget_name;

  WinnerScoreCardItem(
      {this.winners,
      this.id,
      this.start_position,
      this.total,
      this.price,
      this.description,
      this.is_gadget,
      this.gadget_image,
      this.gadget_name});

  factory WinnerScoreCardItem.fromJson(Map<String, dynamic> json) =>
      _$WinnerScoreCardItemFromJson(json);
  Map<String, dynamic> toJson() => _$WinnerScoreCardItemToJson(this);
}

@JsonSerializable()
class ScoreCardResponse {
  int? status;
  String? message;
  List<WinnerScoreCardItem>? result;

  ScoreCardResponse({this.status, this.message, this.result});

  factory ScoreCardResponse.fromJson(Map<String, dynamic> json) =>
      _$ScoreCardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreCardResponseToJson(this);
}
