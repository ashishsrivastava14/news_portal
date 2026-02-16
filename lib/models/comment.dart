class Comment {
  final String id;
  final String articleId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;

  Comment({
    required this.id,
    required this.articleId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.likes = 0,
  });
}
