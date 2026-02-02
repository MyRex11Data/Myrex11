import 'package:json_annotation/json_annotation.dart';
part 'transactions_request.g.dart';

@JsonSerializable()
class TransactionRequest {
  String? user_id;
  String? end_date;
  String? start_date;
  String? filter_type;
  String? status;
  int? page;

  TransactionRequest(
      {this.user_id,
      this.end_date,
      this.start_date,
      this.filter_type,
      this.status,
      this.page});

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionRequestToJson(this);
}
