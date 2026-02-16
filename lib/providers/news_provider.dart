import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../models/comment.dart';
import '../models/notification.dart';
import '../models/user.dart';
import '../services/mock_data.dart';

class NewsProvider extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  List<Category> _categories = [];
  List<Comment> _comments = [];
  List<AppNotification> _notifications = [];
  List<AppUser> _users = [];
  List<String> _bookmarkedIds = [];
  List<String> _recentSearches = [];
  String _selectedCategoryId = 'all';
  bool _isLoading = false;
  String _searchQuery = '';

  // Getters
  List<Article> get articles => _filteredArticles;
  List<Article> get allArticles => _articles;
  List<Category> get categories => _categories;
  List<Comment> get comments => _comments;
  List<AppNotification> get notifications => _notifications;
  List<AppUser> get users => _users;
  List<String> get bookmarkedIds => _bookmarkedIds;
  List<String> get recentSearches => _recentSearches;
  String get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<Article> get breakingNews =>
      _articles.where((a) => a.isBreaking && a.isPublished).toList();

  List<Article> get bookmarkedArticles =>
      _articles.where((a) => _bookmarkedIds.contains(a.id)).toList();

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  NewsProvider() {
    _loadData();
  }

  void _loadData() {
    _articles = List.from(MockData.articles);
    _categories = List.from(MockData.categories);
    _comments = List.from(MockData.comments);
    _notifications = List.from(MockData.notifications);
    _users = List.from(MockData.users);
    _filteredArticles = _articles.where((a) => a.isPublished).toList();
  }

  // Category filtering
  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _filterArticles();
    notifyListeners();
  }

  void _filterArticles() {
    if (_selectedCategoryId == 'all') {
      _filteredArticles = _articles.where((a) => a.isPublished).toList();
    } else {
      _filteredArticles = _articles
          .where((a) => a.categoryId == _selectedCategoryId && a.isPublished)
          .toList();
    }
  }

  // Search
  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filterArticles();
    } else {
      _filteredArticles = _articles
          .where((a) =>
              a.isPublished &&
              (a.title.toLowerCase().contains(query.toLowerCase()) ||
                  a.summary.toLowerCase().contains(query.toLowerCase()) ||
                  a.tags.any((t) => t.toLowerCase().contains(query.toLowerCase()))))
          .toList();
    }
    notifyListeners();
  }

  void addRecentSearch(String query) {
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  // Bookmarks
  void toggleBookmark(String articleId) {
    if (_bookmarkedIds.contains(articleId)) {
      _bookmarkedIds.remove(articleId);
    } else {
      _bookmarkedIds.add(articleId);
    }
    notifyListeners();
  }

  bool isBookmarked(String articleId) => _bookmarkedIds.contains(articleId);

  void removeBookmark(String articleId) {
    _bookmarkedIds.remove(articleId);
    notifyListeners();
  }

  // Comments
  List<Comment> getCommentsForArticle(String articleId) =>
      _comments.where((c) => c.articleId == articleId).toList();

  void addComment(String articleId, String content) {
    final comment = Comment(
      id: 'c${_comments.length + 1}',
      articleId: articleId,
      userName: 'You',
      userAvatar: 'https://i.pravatar.cc/150?img=70',
      content: content,
      createdAt: DateTime.now(),
    );
    _comments.insert(0, comment);
    notifyListeners();
  }

  // Notifications
  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Related articles
  List<Article> getRelatedArticles(String articleId) {
    final article = _articles.firstWhere((a) => a.id == articleId);
    return _articles
        .where((a) =>
            a.id != articleId &&
            a.isPublished &&
            a.categoryId == article.categoryId)
        .take(5)
        .toList();
  }

  // Refresh
  Future<void> refreshArticles() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _loadData();
    _filterArticles();
    _isLoading = false;
    notifyListeners();
  }

  // Admin operations
  void addArticle(Article article) {
    _articles.insert(0, article);
    _filterArticles();
    notifyListeners();
  }

  void updateArticle(Article article) {
    final index = _articles.indexWhere((a) => a.id == article.id);
    if (index != -1) {
      _articles[index] = article;
      _filterArticles();
      notifyListeners();
    }
  }

  void deleteArticle(String id) {
    _articles.removeWhere((a) => a.id == id);
    _filterArticles();
    notifyListeners();
  }

  void toggleArticlePublish(String id) {
    final index = _articles.indexWhere((a) => a.id == id);
    if (index != -1) {
      _articles[index] = _articles[index].copyWith(
        isPublished: !_articles[index].isPublished,
      );
      _filterArticles();
      notifyListeners();
    }
  }

  // Category management
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(Category category) {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // User management
  void toggleUserBlock(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = _users[index].copyWith(
        isBlocked: !_users[index].isBlocked,
      );
      notifyListeners();
    }
  }
}
