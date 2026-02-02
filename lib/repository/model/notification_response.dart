import 'package:json_annotation/json_annotation.dart';
part 'notification_response.g.dart';

@JsonSerializable()
class NotificationItem{
  String? created_at;
  String? title;

  NotificationItem({this.created_at, this.title});

  factory NotificationItem.fromJson(Map<String, dynamic> json) => _$NotificationItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationItemToJson(this);
}

@JsonSerializable()
class GetNotificationResponse{
  int? status;
  String? message;
  List<NotificationItem>? result;

  GetNotificationResponse({this.status, this.message, this.result});

  factory GetNotificationResponse.fromJson(Map<String, dynamic> json) => _$GetNotificationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetNotificationResponseToJson(this);

}