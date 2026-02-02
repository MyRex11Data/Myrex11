// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_offer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOfferResponse _$GetOfferResponseFromJson(Map<String, dynamic> json) =>
    GetOfferResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: (json['result'] as List<dynamic>?)
          ?.map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetOfferResponseToJson(GetOfferResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      team: json['team'] as String?,
      entryfee: (json['entryfee'] as num?)?.toInt(),
      offer: json['offer'] as String?,
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'team': instance.team,
      'entryfee': instance.entryfee,
      'offer': instance.offer,
    };
