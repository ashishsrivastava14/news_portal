class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'breaking', 'article', 'system'
  final DateTime createdAt;
  bool isRead;
  final String? articleId;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.articleId,
  });
}
