import 'package:collection/collection.dart';

extension StringExtensions on String {
  /// Capitalizes each word in the string
  /// Example: "hello world" -> "Hello World"
  String capitalize() =>
      split(' ').map((e) => '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}').join(' ');

  /// Converts string to snake_case
  /// Example: "Hello World" -> "hello_world"
  String toSnakeCase() => split(' ').join('_').toLowerCase();

  /// Converts snake_case to regular case
  /// Example: "hello_world" -> "hello world"
  String snakeCaseToRegularCase() => split('_').join(' ');

  /// Converts snake_case to camelCase
  /// Example: "hello_world" -> "helloWorld"
  String snakeCaseToCamelCase() => split('_')
      .mapIndexed((i, e) => i != 0 ? '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}' : e)
      .join('');
}

extension NullOrEmptyString on String? {
  /// Returns true if string is null, 'null', or empty
  bool get isNullOrEmpty => this == null || this == 'null' || this!.isEmpty;
}
