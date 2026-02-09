// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(languageService)
const languageServiceProvider = LanguageServiceProvider._();

final class LanguageServiceProvider
    extends
        $FunctionalProvider<LanguageService, LanguageService, LanguageService>
    with $Provider<LanguageService> {
  const LanguageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageServiceHash();

  @$internal
  @override
  $ProviderElement<LanguageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LanguageService create(Ref ref) {
    return languageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LanguageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LanguageService>(value),
    );
  }
}

String _$languageServiceHash() => r'f162269a8d1e02a050c80c83371275fed2699b43';
