// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'35b647df37daa7afbf615f587d84ea3b81af58dd';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$userDataHash() => r'2c3182be4558eb8f149b5880091ccaaec07d4316';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userData].
@ProviderFor(userData)
const userDataProvider = UserDataFamily();

/// See also [userData].
class UserDataFamily extends Family<AsyncValue<User>> {
  /// See also [userData].
  const UserDataFamily();

  /// See also [userData].
  UserDataProvider call(
    int id,
  ) {
    return UserDataProvider(
      id,
    );
  }

  @override
  UserDataProvider getProviderOverride(
    covariant UserDataProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userDataProvider';
}

/// See also [userData].
class UserDataProvider extends AutoDisposeFutureProvider<User> {
  /// See also [userData].
  UserDataProvider(
    int id,
  ) : this._internal(
          (ref) => userData(
            ref as UserDataRef,
            id,
          ),
          from: userDataProvider,
          name: r'userDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userDataHash,
          dependencies: UserDataFamily._dependencies,
          allTransitiveDependencies: UserDataFamily._allTransitiveDependencies,
          id: id,
        );

  UserDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<User> Function(UserDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserDataProvider._internal(
        (ref) => create(ref as UserDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _UserDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserDataProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserDataRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `id` of this provider.
  int get id;
}

class _UserDataProviderElement extends AutoDisposeFutureProviderElement<User>
    with UserDataRef {
  _UserDataProviderElement(super.provider);

  @override
  int get id => (origin as UserDataProvider).id;
}

String _$someUsersHash() => r'2cf1fa7a5b14f9c544cf7204c8b0ba8c0f49f3b2';

/// See also [someUsers].
@ProviderFor(someUsers)
final someUsersProvider = AutoDisposeFutureProvider<List<User>>.internal(
  someUsers,
  name: r'someUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$someUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SomeUsersRef = AutoDisposeFutureProviderRef<List<User>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
