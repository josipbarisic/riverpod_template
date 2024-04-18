// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseApiHash() => r'252b7f0acb43a001e2d2f17b6c33dfcf3bddca45';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
