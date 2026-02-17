import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../utils/routes.dart';
import '../../widgets/breaking_news_banner.dart';
import '../../widgets/news_card.dart';
import '../../widgets/shimmer_loader.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsProvider = context.watch<NewsProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => newsProvider.refreshArticles(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.newspaper_rounded,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QuickPrepAI News',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Feb 16, 2026',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_outlined),
                            if (newsProvider.unreadNotificationCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.notifications);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Category chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 46,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: newsProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = newsProvider.categories[index];
                      final isSelected =
                          newsProvider.selectedCategoryId == category.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: isSelected,
                          onSelected: (_) {
                            newsProvider.selectCategory(category.id);
                          },
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          selectedColor: theme.colorScheme.primary,
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Breaking news banner
              if (newsProvider.selectedCategoryId == 'all')
                SliverToBoxAdapter(
                  child: BreakingNewsBanner(
                    articles: newsProvider.breakingNews,
                    onTap: (article) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.articleDetail,
                        arguments: article,
                      );
                    },
                  ),
                ),

              if (newsProvider.selectedCategoryId == 'all')
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Section header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        newsProvider.selectedCategoryId == 'all'
                            ? 'Latest News'
                            : newsProvider.categories
                                .firstWhere(
                                    (c) => c.id == newsProvider.selectedCategoryId)
                                .name,
                        style: theme.textTheme.titleLarge,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
              ),

              // Articles
              if (newsProvider.isLoading)
                SliverToBoxAdapter(
                  child: ShimmerListLoader(itemCount: 3, isCompact: true),
                )
              else if (newsProvider.articles.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 60,
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No articles found',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try selecting a different category',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        // First article as full card
                        return NewsCard(
                          article: newsProvider.articles[0],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.articleDetail,
                              arguments: newsProvider.articles[0],
                            );
                          },
                        );
                      }
                      final articleIndex = index;
                      if (articleIndex >= newsProvider.articles.length) {
                        return null;
                      }
                      return NewsCard(
                        article: newsProvider.articles[articleIndex],
                        isCompact: true,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.articleDetail,
                            arguments: newsProvider.articles[articleIndex],
                          );
                        },
                      );
                    },
                    childCount: newsProvider.articles.length,
                  ),
                ),

              // Loading indicator
              if (_isLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
