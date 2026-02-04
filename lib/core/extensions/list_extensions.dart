extension UpdateListElementExtension<T> on List<T> {
  /// Updates the element at the given index with the new value.
  /// If the index is out of bounds, nothing happens.
  void updateAt(int index, T newValue) {
    if (index >= 0 && index < length) {
      this[index] = newValue;
    }
  }

  /// Returns the list copy with the new value at the given index.
  /// If the index is out of bounds, list copy will be the same as the original.
  List<T> copyWith(int index, T newValue) {
    if (index >= 0 && index < length) {
      this[index] = newValue;
    }
    return List<T>.from(this);
  }

  /// Duplicates the list by appending a copy of itself
  List<T> duplicateList() => [...List.of(this), ...List.of(this)];
}

extension ListExtensions<T> on List<T>? {
  /// Checks if the list is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
