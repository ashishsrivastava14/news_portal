import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../utils/routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/news_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsProvider = context.watch<NewsProvider>();
    final bookmarked = newsProvider.bookmarkedArticles;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text('Saved Articles', style: theme.textTheme.headlineMedium),
                  const Spacer(),
                  if (bookmarked.isNotEmpty)
                    Text(
                      '${bookmarked.length} articles',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Expanded(
              child: bookmarked.isEmpty
                  ? const EmptyState(
                      icon: Icons.bookmark_outline,
                      title: 'No saved articles',
                      subtitle:
                          'Articles you bookmark will appear here for easy access',
                    )
                  : ListView.builder(
                      itemCount: bookmarked.length,
                      itemBuilder: (context, index) {
                        final article = bookmarked[index];
                        return Dismissible(
                          key: Key(article.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) {
                            newsProvider.removeBookmark(article.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Article removed from bookmarks'),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    newsProvider.toggleBookmark(article.id);
                                  },
                                ),
                              ),
                            );
                          },
                          child: NewsCard(
                            article: article,
                            isCompact: true,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.articleDetail,
                                arguments: article,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
