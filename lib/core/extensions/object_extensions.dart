extension TypeCast on Object? {
  /// Safely cast an object to a given type. Returns null if the cast fails.
  T? safeCast<T>() {
    try {
      return this as T;
    } catch (e) {
      return null;
    }
  }
}
