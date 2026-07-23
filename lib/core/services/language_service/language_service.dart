import 'dart:developer';

import 'package:riverpod_template/core/services/network_service/network_service.dart';
import 'package:riverpod_template/core/utils/network/network_response.dart';

/// Manages app language/translations fetched from a remote source.
///
/// Usage:
/// ```dart
/// // Fetch translations at app startup:
/// await ref.read(languageServiceProvider).fetchTranslations();
///
/// // Access a translation:
/// LanguageService.translations['welcomeTitle']
/// ```
class LanguageService {
  LanguageService({required this.networkService});

  final NetworkService networkService;

  late String _appLanguage;

  static Map<String, String> _translations = {};

  String get appLanguage => _appLanguage;

  static Map<String, String> get translations => _translations;

  /// Fetches translations from the configured endpoint.
  ///
  /// Override [translationsUrl] with your actual translations endpoint.
  Future<void> fetchTranslations({
    String language = 'en',
    String? translationsUrl,
  }) async {
    if (translationsUrl == null) {
      log('LanguageService: No translations URL configured, skipping fetch.');
      _appLanguage = language;
      return;
    }

    await networkService
        .getHttp(
          baseURL: translationsUrl,
          headers: {'Cache-Control': 'max-age=0'},
          endpoint: '',
        )
        .then<void>((response) {
      if (response is NetworkSuccessResponse) {
        _translations = Map<String, String>.from(response.data as Map<String, dynamic>);
      }
    }).catchError((Object e) => log('Error in fetching translations: $e'));

    _appLanguage = language;
  }

  void setLanguage(String language) => _appLanguage = language;
}
