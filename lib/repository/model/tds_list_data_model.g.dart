// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tds_list_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TdsListData _$TdsListDataFromJson(Map<String, dynamic> json) => TdsListData(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TdsListDataToJson(TdsListData instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      trasaction_list: (json['trasaction_list'] as List<dynamic>?)
          ?.map((e) => TrasactionList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'trasaction_list': instance.trasaction_list,
    };

TrasactionList _$TrasactionListFromJson(Map<String, dynamic> json) =>
    TrasactionList(
      text: json['text'] as String?,
      tds_date: json['tds_date'] as String?,
      tds_amount: json['tds_amount'] as String?,
    );

Map<String, dynamic> _$TrasactionListToJson(TrasactionList instance) =>
    <String, dynamic>{
      'text': instance.text,
      'tds_date': instance.tds_date,
      'tds_amount': instance.tds_amount,
    };
