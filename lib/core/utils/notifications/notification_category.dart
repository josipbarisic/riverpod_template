enum NotificationCategory {
  general(
    channelId: 'general',
    channelName: 'General channel',
    description: 'General notifications channel for the app.',
  );

  final String channelId;
  final String channelName;
  final String description;

  const NotificationCategory({
    required this.channelId,
    required this.channelName,
    required this.description,
  });
}
