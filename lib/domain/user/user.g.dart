// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
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
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
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
    };
