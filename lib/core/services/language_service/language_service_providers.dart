import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_template/core/services/language_service/language_service.dart';
import 'package:riverpod_template/core/services/network_service/network_service_providers.dart';

part 'language_service_providers.g.dart';

@Riverpod(keepAlive: true)
LanguageService languageService(Ref ref) =>
    LanguageService(networkService: ref.read(networkServiceProvider));
