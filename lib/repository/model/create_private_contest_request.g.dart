// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_private_contest_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WinnerBreakUpData _$WinnerBreakUpDataFromJson(Map<String, dynamic> json) =>
    WinnerBreakUpData(
      rank: json['rank'] as String?,
      winningPer: json['winningPer'] as String?,
      winningAmmount: json['winningAmmount'] as String?,
    );

Map<String, dynamic> _$WinnerBreakUpDataToJson(WinnerBreakUpData instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'winningPer': instance.winningPer,
      'winningAmmount': instance.winningAmmount,
    };

CreatePrivateContestRequest _$CreatePrivateContestRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePrivateContestRequest(
      entryfee: json['entryfee'] as String?,
      matchkey: json['matchkey'] as String?,
      name: json['name'] as String?,
      is_public: json['is_public'] as String?,
      multi_entry: json['multi_entry'] as String?,
      win_amount: json['win_amount'] as String?,
      user_id: json['user_id'] as String?,
      maximum_user: json['maximum_user'] as String?,
      sport_key: json['sport_key'] as String?,
      fantasy_type: json['fantasy_type'] as String?,
      slotes_id: json['slotes_id'] as String?,
      pricecards: (json['pricecards'] as List<dynamic>?)
          ?.map((e) => WinnerBreakUpData.fromJson(e as Map<String, dynamic>))
          .toList(),
      fantasy_type_id: json['fantasy_type_id'] as String?,
    );

Map<String, dynamic> _$CreatePrivateContestRequestToJson(
        CreatePrivateContestRequest instance) =>
    <String, dynamic>{
      'entryfee': instance.entryfee,
      'matchkey': instance.matchkey,
      'name': instance.name,
      'is_public': instance.is_public,
      'multi_entry': instance.multi_entry,
      'win_amount': instance.win_amount,
      'user_id': instance.user_id,
      'maximum_user': instance.maximum_user,
      'sport_key': instance.sport_key,
      'fantasy_type': instance.fantasy_type,
      'slotes_id': instance.slotes_id,
      'fantasy_type_id': instance.fantasy_type_id,
      'pricecards': instance.pricecards,
    };
