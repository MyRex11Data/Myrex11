// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailValue _$UserDetailValueFromJson(Map<String, dynamic> json) =>
    UserDetailValue(
      DayOfBirth: json['DayOfBirth'] as String?,
      country: json['country'] as String?,
      gender: json['gender'] as String?,
      city: json['city'] as String?,
      totalchallenges: (json['totalchallenges'] as num?)?.toInt(),
      dobfreeze: (json['dobfreeze'] as num?)?.toInt(),
      teamfreeze: (json['teamfreeze'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      user_id: json['user_id'] as String?,
      verified: (json['verified'] as num?)?.toInt(),
      mobilefreeze: (json['mobilefreeze'] as num?)?.toInt(),
      emailfreeze: (json['emailfreeze'] as num?)?.toInt(),
      walletamaount: (json['walletamaount'] as num?)?.toInt(),
      statefreeze: (json['statefreeze'] as num?)?.toInt(),
      provider: json['provider'] as String?,
      YearOfBirth: json['YearOfBirth'] as String?,
      state: json['state'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      pincode: json['pincode'] as String?,
      address: json['address'] as String?,
      mobile: json['mobile'],
      team: json['team'] as String?,
      activation_status: json['activation_status'] as String?,
      dob: json['dob'] as String?,
      refercode: json['refercode'] as String?,
      MonthOfBirth: json['MonthOfBirth'] as String?,
      username: json['username'] as String?,
      totalwon: json['totalwon'],
      nationalId: json['nationalId'] as String?,
    );

Map<String, dynamic> _$UserDetailValueToJson(UserDetailValue instance) =>
    <String, dynamic>{
      'DayOfBirth': instance.DayOfBirth,
      'country': instance.country,
      'gender': instance.gender,
      'city': instance.city,
      'totalchallenges': instance.totalchallenges,
      'dobfreeze': instance.dobfreeze,
      'teamfreeze': instance.teamfreeze,
      'id': instance.id,
      'user_id': instance.user_id,
      'verified': instance.verified,
      'mobilefreeze': instance.mobilefreeze,
      'emailfreeze': instance.emailfreeze,
      'walletamaount': instance.walletamaount,
      'statefreeze': instance.statefreeze,
      'provider': instance.provider,
      'YearOfBirth': instance.YearOfBirth,
      'state': instance.state,
      'email': instance.email,
      'image': instance.image,
      'pincode': instance.pincode,
      'address': instance.address,
      'mobile': instance.mobile,
      'team': instance.team,
      'activation_status': instance.activation_status,
      'dob': instance.dob,
      'refercode': instance.refercode,
      'MonthOfBirth': instance.MonthOfBirth,
      'username': instance.username,
      'totalwon': instance.totalwon,
      'nationalId': instance.nationalId,
    };

UserDetailItem _$UserDetailItemFromJson(Map<String, dynamic> json) =>
    UserDetailItem(
      value: json['value'] == null
          ? null
          : UserDetailValue.fromJson(json['value'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDetailItemToJson(UserDetailItem instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

GetUserFullDetailsResponse _$GetUserFullDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    GetUserFullDetailsResponse(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      result: json['result'] == null
          ? null
          : UserDetailItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetUserFullDetailsResponseToJson(
        GetUserFullDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'result': instance.result,
    };
