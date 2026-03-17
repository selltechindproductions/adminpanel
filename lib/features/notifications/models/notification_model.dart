class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String imageUrl;
  final String target; // e.g., 'all', 'android', 'ios', or a specific user ID
  final DateTime sentAt;
  final String status; // 'Sent', 'Failed', 'Draft'

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl = '',
    this.target = 'all',
    required this.sentAt,
    this.status = 'Sent',
  });
}
