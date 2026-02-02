import 'package:json_annotation/json_annotation.dart';
part 'user_details_response.g.dart';

@JsonSerializable()
class UserDetailValue {
  String? DayOfBirth;
  String? country;
  String? gender;
  String? city;
  int? totalchallenges;
  int? dobfreeze;
  int? teamfreeze;
  int? id;
  String? user_id;
  int? verified;
  int? mobilefreeze;
  int? emailfreeze;
  int? walletamaount;
  int? statefreeze;
  String? provider;
  String? YearOfBirth;
  String? state;
  String? email;
  String? image;
  String? pincode;
  String? address;
  var mobile;
  String? team;
  String? activation_status;
  String? dob;
  String? refercode;
  String? MonthOfBirth;
  String? username;
  var totalwon;
  String? nationalId;

  UserDetailValue(
      {this.DayOfBirth,
      this.country,
      this.gender,
      this.city,
      this.totalchallenges,
      this.dobfreeze,
      this.teamfreeze,
      this.id,
      this.user_id,
      this.verified,
      this.mobilefreeze,
      this.emailfreeze,
      this.walletamaount,
      this.statefreeze,
      this.provider,
      this.YearOfBirth,
      this.state,
      this.email,
      this.image,
      this.pincode,
      this.address,
      this.mobile,
      this.team,
      this.activation_status,
      this.dob,
      this.refercode,
      this.MonthOfBirth,
      this.username,
      this.totalwon,
      this.nationalId});

  factory UserDetailValue.fromJson(Map<String, dynamic> json) =>
      _$UserDetailValueFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailValueToJson(this);
}

@JsonSerializable()
class UserDetailItem {
  UserDetailValue? value;

  UserDetailItem({this.value});

  factory UserDetailItem.fromJson(Map<String, dynamic> json) =>
      _$UserDetailItemFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailItemToJson(this);
}

@JsonSerializable()
class GetUserFullDetailsResponse {
  int? status;
  String? message;
  UserDetailItem? result;

  GetUserFullDetailsResponse({this.status, this.message, this.result});
  // LoginResponse({required this.status,required this.message,required this.is_mobile, this.meta, required this.data});
  factory GetUserFullDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserFullDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetUserFullDetailsResponseToJson(this);
}
