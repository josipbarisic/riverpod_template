extension DoubleToString on double? {
  /// Converts a double to a string with two decimal places.
  /// If the double is a whole number, it will be converted to an integer string.
  /// Returns 'N/A' if null.
  String get roundedToString {
    if (this == null) return 'N/A';
    final rounded = this!.toStringAsFixed(2);
    return rounded.endsWith('.00') ? this!.toInt().toString() : rounded;
  }
}
