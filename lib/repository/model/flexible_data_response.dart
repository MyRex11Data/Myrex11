import 'package:json_annotation/json_annotation.dart';
part 'flexible_data_response.g.dart';

@JsonSerializable()
class FlexibleDataResponse {
  int? status;
  Result? result;

  FlexibleDataResponse({this.status, this.result});


  factory FlexibleDataResponse.fromJson(Map<String, dynamic> json) => _$FlexibleDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FlexibleDataResponseToJson(this);
}

@JsonSerializable()
class Result {
  String? max_price_pool;
  String? current_price_pool;
  String? left_spot;
  String? total_spot;
  String? totalwinners;
  String? totalwinners_percentage;
  List<MaxFillC>? MaxFill;
  List<CurrentFillC>? CurrentFill;

  Result(
      {this.max_price_pool,
        this.current_price_pool,
        this.left_spot,
        this.total_spot,
        this.totalwinners,
        this.totalwinners_percentage,
        this.MaxFill,
        this.CurrentFill});

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);

}

@JsonSerializable()
class MaxFillC {
  String? id;
  String? totalwinners;
  String? price;
  String? start_position;
  String? total;
  String? first_rank_prize;
  int? is_gadget;
  String? gadget_image;

  MaxFillC(
      {this.id,
        this.totalwinners,
        this.price,
        this.start_position,
        this.total,
        this.first_rank_prize,
        this.is_gadget,
        this.gadget_image});

  factory MaxFillC.fromJson(Map<String, dynamic> json) => _$MaxFillCFromJson(json);
  Map<String, dynamic> toJson() => _$MaxFillCToJson(this);
}

@JsonSerializable()
class CurrentFillC {
  String? totalwinners;
  String? matchkey;
  String? challenge_id;
  dynamic winners;
  dynamic price;
  dynamic min_position;
  dynamic max_position;
  String? start_position;
  String? total;

  CurrentFillC({this.totalwinners, this.price, this.start_position, this.total,this.min_position,this.challenge_id,
  this.matchkey,this.max_position,this.winners});

  factory CurrentFillC.fromJson(Map<String, dynamic> json) => _$CurrentFillCFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentFillCToJson(this);
}
