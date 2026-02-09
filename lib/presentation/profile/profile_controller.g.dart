// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controls user profile viewing and editing.
///
/// Reads from [UserHandler] for current user state and uses
/// [UserRepository] for backend updates.
///
/// State semantics:
/// - `AsyncData(user)` — user profile loaded
/// - `AsyncLoading` — fetching or updating
/// - `AsyncError` — failed with message

@ProviderFor(ProfileController)
const profileControllerProvider = ProfileControllerProvider._();

/// Controls user profile viewing and editing.
///
/// Reads from [UserHandler] for current user state and uses
/// [UserRepository] for backend updates.
///
/// State semantics:
/// - `AsyncData(user)` — user profile loaded
/// - `AsyncLoading` — fetching or updating
/// - `AsyncError` — failed with message
final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, User?> {
  /// Controls user profile viewing and editing.
  ///
  /// Reads from [UserHandler] for current user state and uses
  /// [UserRepository] for backend updates.
  ///
  /// State semantics:
  /// - `AsyncData(user)` — user profile loaded
  /// - `AsyncLoading` — fetching or updating
  /// - `AsyncError` — failed with message
  const ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'8ca8c20497e111de4578eef53f07c6b92369f12e';

/// Controls user profile viewing and editing.
///
/// Reads from [UserHandler] for current user state and uses
/// [UserRepository] for backend updates.
///
/// State semantics:
/// - `AsyncData(user)` — user profile loaded
/// - `AsyncLoading` — fetching or updating
/// - `AsyncError` — failed with message

abstract class _$ProfileController extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
