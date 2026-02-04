extension DurationExtensions on Duration {
  /// Formats duration as "HH:mm"
  /// Example: Duration(hours: 2, minutes: 30) -> "02:30"
  String get inFormattedHoursAndMinutes {
    final totalMinutes = inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes';
  }
}
