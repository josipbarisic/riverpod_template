// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global user state provider. Keeps the current user alive across
/// the entire app lifecycle so any feature can check auth state.

@ProviderFor(UserHandler)
const userHandlerProvider = UserHandlerProvider._();

/// Global user state provider. Keeps the current user alive across
/// the entire app lifecycle so any feature can check auth state.
final class UserHandlerProvider extends $NotifierProvider<UserHandler, User?> {
  /// Global user state provider. Keeps the current user alive across
  /// the entire app lifecycle so any feature can check auth state.
  const UserHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userHandlerHash();

  @$internal
  @override
  UserHandler create() => UserHandler();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$userHandlerHash() => r'5d2b4713667e7e1ca0f3f87be821b9964163831a';

/// Global user state provider. Keeps the current user alive across
/// the entire app lifecycle so any feature can check auth state.

abstract class _$UserHandler extends $Notifier<User?> {
  User? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<User?, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<User?, User?>,
              User?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
