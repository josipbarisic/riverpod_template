import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String description;
  final Map<String, dynamic>? payload;
  final DateTime scheduledDate;

  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    this.payload = const {},
    required this.scheduledDate,
  });

  @override
  List<Object?> get props => [id, title, description, payload, scheduledDate];
}
