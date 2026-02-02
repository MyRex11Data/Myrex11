// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tds_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTDSData _$GetTDSDataFromJson(Map<String, dynamic> json) => GetTDSData(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$GetTDSDataToJson(GetTDSData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
      'message': instance.message,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      tds_percent: json['tds_percent'],
      tds_amount: json['tds_amount'],
      amount: json['amount'],
      total_amount: json['total_amount'],
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'tds_percent': instance.tds_percent,
      'tds_amount': instance.tds_amount,
      'amount': instance.amount,
      'total_amount': instance.total_amount,
    };
