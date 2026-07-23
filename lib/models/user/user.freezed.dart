// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get id; String get email; String get firstName; String get lastName;// Remove if Firebase is not used
 String get firebaseUserId; DateTime? get createdAt; DateTime? get updatedAt; DateTime? get dob; String? get phoneNumber; String? get gender; bool? get verified;// --- Extended profile fields ---
 String? get bio; String? get companyName; String? get title; String? get profileImageUrl; String? get primaryAddressCity; String? get primaryAddressState; String? get primaryAddressCountry; String? get primaryAddressStreetOne; String? get primaryAddressStreetTwo; String? get primaryAddressZipCode; bool? get newsletter;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firebaseUserId, firebaseUserId) || other.firebaseUserId == firebaseUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.title, title) || other.title == title)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.primaryAddressCity, primaryAddressCity) || other.primaryAddressCity == primaryAddressCity)&&(identical(other.primaryAddressState, primaryAddressState) || other.primaryAddressState == primaryAddressState)&&(identical(other.primaryAddressCountry, primaryAddressCountry) || other.primaryAddressCountry == primaryAddressCountry)&&(identical(other.primaryAddressStreetOne, primaryAddressStreetOne) || other.primaryAddressStreetOne == primaryAddressStreetOne)&&(identical(other.primaryAddressStreetTwo, primaryAddressStreetTwo) || other.primaryAddressStreetTwo == primaryAddressStreetTwo)&&(identical(other.primaryAddressZipCode, primaryAddressZipCode) || other.primaryAddressZipCode == primaryAddressZipCode)&&(identical(other.newsletter, newsletter) || other.newsletter == newsletter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,firstName,lastName,firebaseUserId,createdAt,updatedAt,dob,phoneNumber,gender,verified,bio,companyName,title,profileImageUrl,primaryAddressCity,primaryAddressState,primaryAddressCountry,primaryAddressStreetOne,primaryAddressStreetTwo,primaryAddressZipCode,newsletter]);

@override
String toString() {
  return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, firebaseUserId: $firebaseUserId, createdAt: $createdAt, updatedAt: $updatedAt, dob: $dob, phoneNumber: $phoneNumber, gender: $gender, verified: $verified, bio: $bio, companyName: $companyName, title: $title, profileImageUrl: $profileImageUrl, primaryAddressCity: $primaryAddressCity, primaryAddressState: $primaryAddressState, primaryAddressCountry: $primaryAddressCountry, primaryAddressStreetOne: $primaryAddressStreetOne, primaryAddressStreetTwo: $primaryAddressStreetTwo, primaryAddressZipCode: $primaryAddressZipCode, newsletter: $newsletter)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String firstName, String lastName, String firebaseUserId, DateTime? createdAt, DateTime? updatedAt, DateTime? dob, String? phoneNumber, String? gender, bool? verified, String? bio, String? companyName, String? title, String? profileImageUrl, String? primaryAddressCity, String? primaryAddressState, String? primaryAddressCountry, String? primaryAddressStreetOne, String? primaryAddressStreetTwo, String? primaryAddressZipCode, bool? newsletter
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? firebaseUserId = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? dob = freezed,Object? phoneNumber = freezed,Object? gender = freezed,Object? verified = freezed,Object? bio = freezed,Object? companyName = freezed,Object? title = freezed,Object? profileImageUrl = freezed,Object? primaryAddressCity = freezed,Object? primaryAddressState = freezed,Object? primaryAddressCountry = freezed,Object? primaryAddressStreetOne = freezed,Object? primaryAddressStreetTwo = freezed,Object? primaryAddressZipCode = freezed,Object? newsletter = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,firebaseUserId: null == firebaseUserId ? _self.firebaseUserId : firebaseUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,verified: freezed == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressCity: freezed == primaryAddressCity ? _self.primaryAddressCity : primaryAddressCity // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressState: freezed == primaryAddressState ? _self.primaryAddressState : primaryAddressState // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressCountry: freezed == primaryAddressCountry ? _self.primaryAddressCountry : primaryAddressCountry // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressStreetOne: freezed == primaryAddressStreetOne ? _self.primaryAddressStreetOne : primaryAddressStreetOne // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressStreetTwo: freezed == primaryAddressStreetTwo ? _self.primaryAddressStreetTwo : primaryAddressStreetTwo // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressZipCode: freezed == primaryAddressZipCode ? _self.primaryAddressZipCode : primaryAddressZipCode // ignore: cast_nullable_to_non_nullable
as String?,newsletter: freezed == newsletter ? _self.newsletter : newsletter // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String firstName,  String lastName,  String firebaseUserId,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? dob,  String? phoneNumber,  String? gender,  bool? verified,  String? bio,  String? companyName,  String? title,  String? profileImageUrl,  String? primaryAddressCity,  String? primaryAddressState,  String? primaryAddressCountry,  String? primaryAddressStreetOne,  String? primaryAddressStreetTwo,  String? primaryAddressZipCode,  bool? newsletter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.firebaseUserId,_that.createdAt,_that.updatedAt,_that.dob,_that.phoneNumber,_that.gender,_that.verified,_that.bio,_that.companyName,_that.title,_that.profileImageUrl,_that.primaryAddressCity,_that.primaryAddressState,_that.primaryAddressCountry,_that.primaryAddressStreetOne,_that.primaryAddressStreetTwo,_that.primaryAddressZipCode,_that.newsletter);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String firstName,  String lastName,  String firebaseUserId,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? dob,  String? phoneNumber,  String? gender,  bool? verified,  String? bio,  String? companyName,  String? title,  String? profileImageUrl,  String? primaryAddressCity,  String? primaryAddressState,  String? primaryAddressCountry,  String? primaryAddressStreetOne,  String? primaryAddressStreetTwo,  String? primaryAddressZipCode,  bool? newsletter)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.firebaseUserId,_that.createdAt,_that.updatedAt,_that.dob,_that.phoneNumber,_that.gender,_that.verified,_that.bio,_that.companyName,_that.title,_that.profileImageUrl,_that.primaryAddressCity,_that.primaryAddressState,_that.primaryAddressCountry,_that.primaryAddressStreetOne,_that.primaryAddressStreetTwo,_that.primaryAddressZipCode,_that.newsletter);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String firstName,  String lastName,  String firebaseUserId,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? dob,  String? phoneNumber,  String? gender,  bool? verified,  String? bio,  String? companyName,  String? title,  String? profileImageUrl,  String? primaryAddressCity,  String? primaryAddressState,  String? primaryAddressCountry,  String? primaryAddressStreetOne,  String? primaryAddressStreetTwo,  String? primaryAddressZipCode,  bool? newsletter)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.firebaseUserId,_that.createdAt,_that.updatedAt,_that.dob,_that.phoneNumber,_that.gender,_that.verified,_that.bio,_that.companyName,_that.title,_that.profileImageUrl,_that.primaryAddressCity,_that.primaryAddressState,_that.primaryAddressCountry,_that.primaryAddressStreetOne,_that.primaryAddressStreetTwo,_that.primaryAddressZipCode,_that.newsletter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({required this.id, required this.email, required this.firstName, required this.lastName, required this.firebaseUserId, this.createdAt, this.updatedAt, this.dob, this.phoneNumber, this.gender, this.verified, this.bio, this.companyName, this.title, this.profileImageUrl, this.primaryAddressCity, this.primaryAddressState, this.primaryAddressCountry, this.primaryAddressStreetOne, this.primaryAddressStreetTwo, this.primaryAddressZipCode, this.newsletter}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String email;
@override final  String firstName;
@override final  String lastName;
// Remove if Firebase is not used
@override final  String firebaseUserId;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? dob;
@override final  String? phoneNumber;
@override final  String? gender;
@override final  bool? verified;
// --- Extended profile fields ---
@override final  String? bio;
@override final  String? companyName;
@override final  String? title;
@override final  String? profileImageUrl;
@override final  String? primaryAddressCity;
@override final  String? primaryAddressState;
@override final  String? primaryAddressCountry;
@override final  String? primaryAddressStreetOne;
@override final  String? primaryAddressStreetTwo;
@override final  String? primaryAddressZipCode;
@override final  bool? newsletter;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.firebaseUserId, firebaseUserId) || other.firebaseUserId == firebaseUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.title, title) || other.title == title)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl)&&(identical(other.primaryAddressCity, primaryAddressCity) || other.primaryAddressCity == primaryAddressCity)&&(identical(other.primaryAddressState, primaryAddressState) || other.primaryAddressState == primaryAddressState)&&(identical(other.primaryAddressCountry, primaryAddressCountry) || other.primaryAddressCountry == primaryAddressCountry)&&(identical(other.primaryAddressStreetOne, primaryAddressStreetOne) || other.primaryAddressStreetOne == primaryAddressStreetOne)&&(identical(other.primaryAddressStreetTwo, primaryAddressStreetTwo) || other.primaryAddressStreetTwo == primaryAddressStreetTwo)&&(identical(other.primaryAddressZipCode, primaryAddressZipCode) || other.primaryAddressZipCode == primaryAddressZipCode)&&(identical(other.newsletter, newsletter) || other.newsletter == newsletter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,firstName,lastName,firebaseUserId,createdAt,updatedAt,dob,phoneNumber,gender,verified,bio,companyName,title,profileImageUrl,primaryAddressCity,primaryAddressState,primaryAddressCountry,primaryAddressStreetOne,primaryAddressStreetTwo,primaryAddressZipCode,newsletter]);

@override
String toString() {
  return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, firebaseUserId: $firebaseUserId, createdAt: $createdAt, updatedAt: $updatedAt, dob: $dob, phoneNumber: $phoneNumber, gender: $gender, verified: $verified, bio: $bio, companyName: $companyName, title: $title, profileImageUrl: $profileImageUrl, primaryAddressCity: $primaryAddressCity, primaryAddressState: $primaryAddressState, primaryAddressCountry: $primaryAddressCountry, primaryAddressStreetOne: $primaryAddressStreetOne, primaryAddressStreetTwo: $primaryAddressStreetTwo, primaryAddressZipCode: $primaryAddressZipCode, newsletter: $newsletter)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String firstName, String lastName, String firebaseUserId, DateTime? createdAt, DateTime? updatedAt, DateTime? dob, String? phoneNumber, String? gender, bool? verified, String? bio, String? companyName, String? title, String? profileImageUrl, String? primaryAddressCity, String? primaryAddressState, String? primaryAddressCountry, String? primaryAddressStreetOne, String? primaryAddressStreetTwo, String? primaryAddressZipCode, bool? newsletter
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = null,Object? lastName = null,Object? firebaseUserId = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? dob = freezed,Object? phoneNumber = freezed,Object? gender = freezed,Object? verified = freezed,Object? bio = freezed,Object? companyName = freezed,Object? title = freezed,Object? profileImageUrl = freezed,Object? primaryAddressCity = freezed,Object? primaryAddressState = freezed,Object? primaryAddressCountry = freezed,Object? primaryAddressStreetOne = freezed,Object? primaryAddressStreetTwo = freezed,Object? primaryAddressZipCode = freezed,Object? newsletter = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,firebaseUserId: null == firebaseUserId ? _self.firebaseUserId : firebaseUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,verified: freezed == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressCity: freezed == primaryAddressCity ? _self.primaryAddressCity : primaryAddressCity // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressState: freezed == primaryAddressState ? _self.primaryAddressState : primaryAddressState // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressCountry: freezed == primaryAddressCountry ? _self.primaryAddressCountry : primaryAddressCountry // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressStreetOne: freezed == primaryAddressStreetOne ? _self.primaryAddressStreetOne : primaryAddressStreetOne // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressStreetTwo: freezed == primaryAddressStreetTwo ? _self.primaryAddressStreetTwo : primaryAddressStreetTwo // ignore: cast_nullable_to_non_nullable
as String?,primaryAddressZipCode: freezed == primaryAddressZipCode ? _self.primaryAddressZipCode : primaryAddressZipCode // ignore: cast_nullable_to_non_nullable
as String?,newsletter: freezed == newsletter ? _self.newsletter : newsletter // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
