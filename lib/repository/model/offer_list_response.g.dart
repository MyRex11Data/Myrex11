// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferListDataModel _$OfferListDataModelFromJson(Map<String, dynamic> json) =>
    OfferListDataModel(
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String?,
      expire_date: json['expire_date'] as String?,
      description: json['description'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$OfferListDataModelToJson(OfferListDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'expire_date': instance.expire_date,
      'description': instance.description,
      'title': instance.title,
    };

OfferResultModel _$OfferResultModelFromJson(Map<String, dynamic> json) =>
    OfferResultModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OfferListDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OfferResultModelToJson(OfferResultModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

OfferListResponse _$OfferListResponseFromJson(Map<String, dynamic> json) =>
    OfferListResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : OfferResultModel.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OfferListResponseToJson(OfferListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
