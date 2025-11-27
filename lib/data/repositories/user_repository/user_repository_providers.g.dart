// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userRepository)
const userRepositoryProvider = UserRepositoryProvider._();

final class UserRepositoryProvider
    extends $FunctionalProvider<UserRepository, UserRepository, UserRepository>
    with $Provider<UserRepository> {
  const UserRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRepository create(Ref ref) {
    return userRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRepository>(value),
    );
  }
}

String _$userRepositoryHash() => r'f0f56701cfe81ec45862030feb9ac9de30fdeb11';

@ProviderFor(userData)
const userDataProvider = UserDataFamily._();

final class UserDataProvider
    extends $FunctionalProvider<AsyncValue<User>, User, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  const UserDataProvider._({
    required UserDataFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'userDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userDataHash();

  @override
  String toString() {
    return r'userDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    final argument = this.argument as int;
    return userData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userDataHash() => r'c42ac378c1544801e22c49b3f677188840750a13';

final class UserDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<User>, int> {
  const UserDataFamily._()
    : super(
        retry: null,
        name: r'userDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserDataProvider call(int id) => UserDataProvider._(argument: id, from: this);

  @override
  String toString() => r'userDataProvider';
}

@ProviderFor(someUsers)
const someUsersProvider = SomeUsersProvider._();

final class SomeUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>
        >
    with $FutureModifier<List<User>>, $FutureProvider<List<User>> {
  const SomeUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'someUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$someUsersHash();

  @$internal
  @override
  $FutureProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<User>> create(Ref ref) {
    return someUsers(ref);
  }
}

String _$someUsersHash() => r'840f5533e4455e18d98c788dc5197c4e5f05cc12';
