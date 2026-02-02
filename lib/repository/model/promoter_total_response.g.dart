// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promoter_total_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoterTotalResult _$PromoterTotalResultFromJson(Map<String, dynamic> json) =>
    PromoterTotalResult(
      winning: json['winning'] as String?,
      deposit: json['deposit'] as String?,
      aff_bal: json['aff_bal'] as String?,
      matches: json['matches'] as String?,
      team_join: json['team_join'] as String?,
      aff_per: json['aff_per'] as String?,
      total_earning: json['total_earning'] as String?,
      total_referal: json['total_referal'] as String?,
      affiliation_tds: json['affiliation_tds'] as String?,
    );

Map<String, dynamic> _$PromoterTotalResultToJson(
        PromoterTotalResult instance) =>
    <String, dynamic>{
      'winning': instance.winning,
      'deposit': instance.deposit,
      'aff_bal': instance.aff_bal,
      'matches': instance.matches,
      'team_join': instance.team_join,
      'total_referal': instance.total_referal,
      'total_earning': instance.total_earning,
      'aff_per': instance.aff_per,
      'affiliation_tds': instance.affiliation_tds,
    };

PromoterTotalResponse _$PromoterTotalResponseFromJson(
        Map<String, dynamic> json) =>
    PromoterTotalResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : PromoterTotalResult.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PromoterTotalResponseToJson(
        PromoterTotalResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
