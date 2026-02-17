import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'models/article.dart';
import 'providers/news_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'utils/app_theme.dart';
import 'utils/routes.dart';
import 'l10n/app_localizations.dart';

// Auth screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

// User screens
import 'screens/main_nav_screen.dart';
import 'screens/user/article_detail_screen.dart';
import 'screens/user/categories_screen.dart';
import 'screens/user/search_screen.dart';
import 'screens/user/bookmarks_screen.dart';
import 'screens/user/profile_screen.dart';
import 'screens/user/notifications_screen.dart';

// Admin screens
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_articles_screen.dart';
import 'screens/admin/admin_create_article_screen.dart';
import 'screens/admin/admin_categories_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'screens/admin/admin_settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NewsPortalApp());
}

class NewsPortalApp extends StatelessWidget {
  const NewsPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) {
          return MaterialApp(
            title: 'QuickPrepAI News',
            debugShowCheckedModeBanner: false,
            
            // Localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageProvider.supportedLocales,
            locale: languageProvider.locale,
            
            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => const SplashScreen(),
              AppRoutes.onboarding: (_) => const OnboardingScreen(),
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const RegisterScreen(),
              AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
              AppRoutes.home: (_) => const MainNavScreen(),
              AppRoutes.search: (_) => const SearchScreen(),
              AppRoutes.bookmarks: (_) => const BookmarksScreen(),
              AppRoutes.profile: (_) => const ProfileScreen(),
              AppRoutes.notifications: (_) => const NotificationsScreen(),
              AppRoutes.adminLogin: (_) => const AdminLoginScreen(),
              AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
              AppRoutes.adminArticles: (_) => const AdminArticlesScreen(),
              AppRoutes.adminCreateArticle: (_) =>
                  const AdminCreateArticleScreen(),
              AppRoutes.adminCategories: (_) =>
                  const AdminCategoriesScreen(),
              AppRoutes.adminUsers: (_) => const AdminUsersScreen(),
              AppRoutes.adminSettings: (_) => const AdminSettingsScreen(),
            },
            onGenerateRoute: (settings) {
              // Handle routes that need arguments
              switch (settings.name) {
                case AppRoutes.articleDetail:
                  final article = settings.arguments as dynamic;
                  return MaterialPageRoute(
                    builder: (_) =>
                        ArticleDetailScreen(article: article),
                  );
                case AppRoutes.categoryFeed:
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (_) => const CategoryFeedScreen(),
                  );
                case AppRoutes.adminEditArticle:
                  final article = settings.arguments as Article?;
                  return MaterialPageRoute(
                    builder: (_) => AdminCreateArticleScreen(
                        article: article),
                  );
                case AppRoutes.categories:
                  return MaterialPageRoute(
                    builder: (_) => const CategoriesScreen(),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(
                        child: Text('Route not found: ${settings.name}'),
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}
