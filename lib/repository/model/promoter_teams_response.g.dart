// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promoter_teams_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoterTeamsData _$PromoterTeamsDataFromJson(Map<String, dynamic> json) =>
    PromoterTeamsData(
      team: json['team'] as String?,
      amount: json['amount'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$PromoterTeamsDataToJson(PromoterTeamsData instance) =>
    <String, dynamic>{
      'team': instance.team,
      'amount': instance.amount,
      'image': instance.image,
    };

PromoterTeamsResponse _$PromoterTeamsResponseFromJson(
        Map<String, dynamic> json) =>
    PromoterTeamsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => PromoterTeamsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromoterTeamsResponseToJson(
        PromoterTeamsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
