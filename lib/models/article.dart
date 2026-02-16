class Article {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String imageUrl;
  final String categoryId;
  final String categoryName;
  final String authorName;
  final String authorAvatar;
  final String source;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final int views;
  final bool isBreaking;
  final bool isPublished;
  final List<String> tags;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryName,
    required this.authorName,
    required this.authorAvatar,
    required this.source,
    required this.publishedAt,
    required this.readTimeMinutes,
    this.views = 0,
    this.isBreaking = false,
    this.isPublished = true,
    this.tags = const [],
  });

  Article copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? imageUrl,
    String? categoryId,
    String? categoryName,
    String? authorName,
    String? authorAvatar,
    String? source,
    DateTime? publishedAt,
    int? readTimeMinutes,
    int? views,
    bool? isBreaking,
    bool? isPublished,
    List<String>? tags,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      source: source ?? this.source,
      publishedAt: publishedAt ?? this.publishedAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      views: views ?? this.views,
      isBreaking: isBreaking ?? this.isBreaking,
      isPublished: isPublished ?? this.isPublished,
      tags: tags ?? this.tags,
    );
  }
}
