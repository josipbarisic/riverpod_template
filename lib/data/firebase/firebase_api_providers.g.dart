// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseApi)
const firebaseApiProvider = FirebaseApiProvider._();

final class FirebaseApiProvider
    extends $FunctionalProvider<FirebaseApi, FirebaseApi, FirebaseApi>
    with $Provider<FirebaseApi> {
  const FirebaseApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseApiHash();

  @$internal
  @override
  $ProviderElement<FirebaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseApi create(Ref ref) {
    return firebaseApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseApi>(value),
    );
  }
}

String _$firebaseApiHash() => r'2ba41767e5415a6f2ec7fb16d0c7a66d0669d16d';

@ProviderFor(HasRemoteMessage)
const hasRemoteMessageProvider = HasRemoteMessageProvider._();

final class HasRemoteMessageProvider
    extends $NotifierProvider<HasRemoteMessage, bool> {
  const HasRemoteMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasRemoteMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasRemoteMessageHash();

  @$internal
  @override
  HasRemoteMessage create() => HasRemoteMessage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasRemoteMessageHash() => r'9393da66eebfa139ba542a5958cde19f455ffa6e';

abstract class _$HasRemoteMessage extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
