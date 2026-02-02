// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tds_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTdsData _$GetTdsDataFromJson(Map<String, dynamic> json) => GetTdsData(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : TdsResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetTdsDataToJson(GetTdsData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };

TdsResult _$TdsResultFromJson(Map<String, dynamic> json) => TdsResult(
      tdsdata: json['tdsdata'] == null
          ? null
          : Tdsdata.fromJson(json['tdsdata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TdsResultToJson(TdsResult instance) => <String, dynamic>{
      'tdsdata': instance.tdsdata,
    };

Tdsdata _$TdsdataFromJson(Map<String, dynamic> json) => Tdsdata(
      financial_year_withdraw: json['financial_year_withdraw'] as String?,
      financial_year: json['financial_year'] as String?,
      total_investment: json['total_investment'] as String?,
      total_winning: json['total_winning'],
      tds_to_be_paid: json['tds_to_be_paid'] as String?,
      tds_paid: json['tds_paid'] as String?,
      opening_balance: json['opening_balance'] as String?,
      total_commission: json['total_commission'],
      total_deposit: json['total_deposit'] as String?,
      total_withdraw: json['total_withdraw'] as String?,
    );

Map<String, dynamic> _$TdsdataToJson(Tdsdata instance) => <String, dynamic>{
      'financial_year': instance.financial_year,
      'financial_year_withdraw': instance.financial_year_withdraw,
      'total_investment': instance.total_investment,
      'opening_balance': instance.opening_balance,
      'total_deposit': instance.total_deposit,
      'total_withdraw': instance.total_withdraw,
      'total_commission': instance.total_commission,
      'total_winning': instance.total_winning,
      'tds_to_be_paid': instance.tds_to_be_paid,
      'tds_paid': instance.tds_paid,
    };
