// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_navigation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BottomNavigationController)
const bottomNavigationControllerProvider =
    BottomNavigationControllerProvider._();

final class BottomNavigationControllerProvider
    extends
        $NotifierProvider<BottomNavigationController, BottomNavigationState> {
  const BottomNavigationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bottomNavigationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bottomNavigationControllerHash();

  @$internal
  @override
  BottomNavigationController create() => BottomNavigationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BottomNavigationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BottomNavigationState>(value),
    );
  }
}

String _$bottomNavigationControllerHash() =>
    r'698c61f52c39540e0606d2df46b3d688d61c572e';

abstract class _$BottomNavigationController
    extends $Notifier<BottomNavigationState> {
  BottomNavigationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BottomNavigationState, BottomNavigationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BottomNavigationState, BottomNavigationState>,
              BottomNavigationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
