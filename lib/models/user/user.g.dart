// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  firebaseUserId: json['firebaseUserId'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
  phoneNumber: json['phoneNumber'] as String?,
  gender: json['gender'] as String?,
  verified: json['verified'] as bool?,
  bio: json['bio'] as String?,
  companyName: json['companyName'] as String?,
  title: json['title'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  primaryAddressCity: json['primaryAddressCity'] as String?,
  primaryAddressState: json['primaryAddressState'] as String?,
  primaryAddressCountry: json['primaryAddressCountry'] as String?,
  primaryAddressStreetOne: json['primaryAddressStreetOne'] as String?,
  primaryAddressStreetTwo: json['primaryAddressStreetTwo'] as String?,
  primaryAddressZipCode: json['primaryAddressZipCode'] as String?,
  newsletter: json['newsletter'] as bool?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'firebaseUserId': instance.firebaseUserId,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'dob': instance.dob?.toIso8601String(),
  'phoneNumber': instance.phoneNumber,
  'gender': instance.gender,
  'verified': instance.verified,
  'bio': instance.bio,
  'companyName': instance.companyName,
  'title': instance.title,
  'profileImageUrl': instance.profileImageUrl,
  'primaryAddressCity': instance.primaryAddressCity,
  'primaryAddressState': instance.primaryAddressState,
  'primaryAddressCountry': instance.primaryAddressCountry,
  'primaryAddressStreetOne': instance.primaryAddressStreetOne,
  'primaryAddressStreetTwo': instance.primaryAddressStreetTwo,
  'primaryAddressZipCode': instance.primaryAddressZipCode,
  'newsletter': instance.newsletter,
};
