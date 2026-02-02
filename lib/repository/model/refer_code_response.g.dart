// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refer_code_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferCodeResponse _$ReferCodeResponseFromJson(Map<String, dynamic> json) =>
    ReferCodeResponse(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReferCodeResponseToJson(ReferCodeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      refer_code: json['refer_code'] as String?,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'refer_code': instance.refer_code,
    };
