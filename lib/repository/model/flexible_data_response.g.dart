// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flexible_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexibleDataResponse _$FlexibleDataResponseFromJson(
        Map<String, dynamic> json) =>
    FlexibleDataResponse(
      status: (json['status'] as num?)?.toInt(),
      result: json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FlexibleDataResponseToJson(
        FlexibleDataResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      max_price_pool: json['max_price_pool'] as String?,
      current_price_pool: json['current_price_pool'] as String?,
      left_spot: json['left_spot'] as String?,
      total_spot: json['total_spot'] as String?,
      totalwinners: json['totalwinners'] as String?,
      totalwinners_percentage: json['totalwinners_percentage'] as String?,
      MaxFill: (json['MaxFill'] as List<dynamic>?)
          ?.map((e) => MaxFillC.fromJson(e as Map<String, dynamic>))
          .toList(),
      CurrentFill: (json['CurrentFill'] as List<dynamic>?)
          ?.map((e) => CurrentFillC.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'max_price_pool': instance.max_price_pool,
      'current_price_pool': instance.current_price_pool,
      'left_spot': instance.left_spot,
      'total_spot': instance.total_spot,
      'totalwinners': instance.totalwinners,
      'totalwinners_percentage': instance.totalwinners_percentage,
      'MaxFill': instance.MaxFill,
      'CurrentFill': instance.CurrentFill,
    };

MaxFillC _$MaxFillCFromJson(Map<String, dynamic> json) => MaxFillC(
      id: json['id'] as String?,
      totalwinners: json['totalwinners'] as String?,
      price: json['price'] as String?,
      start_position: json['start_position'] as String?,
      total: json['total'] as String?,
      first_rank_prize: json['first_rank_prize'] as String?,
      is_gadget: (json['is_gadget'] as num?)?.toInt(),
      gadget_image: json['gadget_image'] as String?,
    );

Map<String, dynamic> _$MaxFillCToJson(MaxFillC instance) => <String, dynamic>{
      'id': instance.id,
      'totalwinners': instance.totalwinners,
      'price': instance.price,
      'start_position': instance.start_position,
      'total': instance.total,
      'first_rank_prize': instance.first_rank_prize,
      'is_gadget': instance.is_gadget,
      'gadget_image': instance.gadget_image,
    };

CurrentFillC _$CurrentFillCFromJson(Map<String, dynamic> json) => CurrentFillC(
      totalwinners: json['totalwinners'] as String?,
      price: json['price'],
      start_position: json['start_position'] as String?,
      total: json['total'] as String?,
      min_position: json['min_position'],
      challenge_id: json['challenge_id'] as String?,
      matchkey: json['matchkey'] as String?,
      max_position: json['max_position'],
      winners: json['winners'],
    );

Map<String, dynamic> _$CurrentFillCToJson(CurrentFillC instance) =>
    <String, dynamic>{
      'totalwinners': instance.totalwinners,
      'matchkey': instance.matchkey,
      'challenge_id': instance.challenge_id,
      'winners': instance.winners,
      'price': instance.price,
      'min_position': instance.min_position,
      'max_position': instance.max_position,
      'start_position': instance.start_position,
      'total': instance.total,
    };
