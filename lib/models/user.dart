class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final DateTime joinedAt;
  final bool isBlocked;
  final bool isAdmin;
  final int articlesRead;
  final int bookmarksCount;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.joinedAt,
    this.isBlocked = false,
    this.isAdmin = false,
    this.articlesRead = 0,
    this.bookmarksCount = 0,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? joinedAt,
    bool? isBlocked,
    bool? isAdmin,
    int? articlesRead,
    int? bookmarksCount,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedAt: joinedAt ?? this.joinedAt,
      isBlocked: isBlocked ?? this.isBlocked,
      isAdmin: isAdmin ?? this.isAdmin,
      articlesRead: articlesRead ?? this.articlesRead,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
    );
  }
}
