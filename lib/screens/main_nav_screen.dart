import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../utils/routes.dart';
import 'user/home_feed_screen.dart';
import 'user/categories_screen.dart';
import 'user/search_screen.dart';
import 'user/bookmarks_screen.dart';
import 'user/profile_screen.dart';
import 'user/article_detail_screen.dart';
import 'user/notifications_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        // Handle nested routes
        switch (settings.name) {
          case AppRoutes.articleDetail:
            final article = settings.arguments as dynamic;
            return MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
              settings: settings,
            );
          case AppRoutes.notifications:
            return MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
              settings: settings,
            );
          case AppRoutes.categoryFeed:
            return MaterialPageRoute(
              builder: (context) => const CategoryFeedScreen(),
              settings: settings,
            );
          default:
            // Default to the root screen for this tab
            return MaterialPageRoute(
              builder: (context) => child,
              settings: settings,
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    final unreadCount = newsProvider.unreadNotificationCount;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        // Try to pop the current tab's navigator
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();

        // If we're on the first route of the current tab
        if (isFirstRouteInCurrentTab) {
          // If not on home tab, switch to home
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildNavigator(0, const HomeFeedScreen()),
            _buildNavigator(1, const CategoriesScreen()),
            _buildNavigator(2, const SearchScreen()),
            _buildNavigator(3, const BookmarksScreen()),
            _buildNavigator(4, const ProfileScreen()),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                activeIcon: Icon(Icons.search),
                label: 'Search',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                activeIcon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.person_outline),
                    if (unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 9 ? '9+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                activeIcon: const Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
