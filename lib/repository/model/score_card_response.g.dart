// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WinnerScoreCardItem _$WinnerScoreCardItemFromJson(Map<String, dynamic> json) =>
    WinnerScoreCardItem(
      winners: (json['winners'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      start_position: json['start_position'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      is_gadget: (json['is_gadget'] as num?)?.toInt(),
      gadget_image: json['gadget_image'] as String?,
      gadget_name: json['gadget_name'] as String?,
    );

Map<String, dynamic> _$WinnerScoreCardItemToJson(
        WinnerScoreCardItem instance) =>
    <String, dynamic>{
      'winners': instance.winners,
      'id': instance.id,
      'start_position': instance.start_position,
      'total': instance.total,
      'price': instance.price,
      'description': instance.description,
      'is_gadget': instance.is_gadget,
      'gadget_image': instance.gadget_image,
      'gadget_name': instance.gadget_name,
    };

ScoreCardResponse _$ScoreCardResponseFromJson(Map<String, dynamic> json) =>
    ScoreCardResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => WinnerScoreCardItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScoreCardResponseToJson(ScoreCardResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
