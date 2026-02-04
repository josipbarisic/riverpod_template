import 'dart:developer';

extension TrimBooleanMapEXT on Map<String, dynamic> {
  /// Removes null values from the map.
  /// If [includeFalseValues] is false (default), also removes false values.
  Map<String, dynamic> trimMap({bool includeFalseValues = false}) => Map<String, dynamic>.from(this)
    ..removeWhere((key, value) => value == null || (includeFalseValues ? false : value == false));

  /// Safely updates a key in the map, logging errors instead of throwing.
  Map<String, dynamic> safeUpdate(String key, dynamic value) {
    try {
      return this..update(key, (_) => value);
    } catch (e) {
      log('Error updating map: $e');
      return this;
    }
  }
}
