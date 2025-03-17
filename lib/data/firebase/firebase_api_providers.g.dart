// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseApiHash() => r'2ba41767e5415a6f2ec7fb16d0c7a66d0669d16d';

/// See also [firebaseApi].
@ProviderFor(firebaseApi)
final firebaseApiProvider = Provider<FirebaseApi>.internal(
  firebaseApi,
  name: r'firebaseApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseApiRef = ProviderRef<FirebaseApi>;
String _$hasRemoteMessageHash() => r'9393da66eebfa139ba542a5958cde19f455ffa6e';

/// See also [HasRemoteMessage].
@ProviderFor(HasRemoteMessage)
final hasRemoteMessageProvider =
    AutoDisposeNotifierProvider<HasRemoteMessage, bool>.internal(
  HasRemoteMessage.new,
  name: r'hasRemoteMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasRemoteMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HasRemoteMessage = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
