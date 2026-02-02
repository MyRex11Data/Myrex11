import 'package:json_annotation/json_annotation.dart';
part 'leaderboard_series_response.g.dart';

@JsonSerializable()
class SeriesItem{
  int? id;
  int? is_leaderboard;
  String? name;
  String? start_date;
  String? end_date;
  String? slug;
  String? series_status;
  String? created_at;


  SeriesItem({this.id, this.is_leaderboard, this.name, this.start_date,
      this.end_date, this.slug, this.series_status, this.created_at});

  factory SeriesItem.fromJson(Map<String, dynamic> json) => _$SeriesItemFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesItemToJson(this);
}

@JsonSerializable()
class SeriesResponse{
  int? status;
  String? message;
  String? url;
  List<SeriesItem>? result;

  SeriesResponse({this.status, this.message,this.url, this.result});

  factory SeriesResponse.fromJson(Map<String, dynamic> json) => _$SeriesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SeriesResponseToJson(this);

}