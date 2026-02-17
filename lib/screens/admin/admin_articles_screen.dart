import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../utils/helpers.dart';
import '../../utils/routes.dart';
import '../../widgets/adaptive_image.dart';

class AdminArticlesScreen extends StatefulWidget {
  const AdminArticlesScreen({super.key});

  @override
  State<AdminArticlesScreen> createState() => _AdminArticlesScreenState();
}

class _AdminArticlesScreenState extends State<AdminArticlesScreen> {
  String _searchQuery = '';
  String _sortBy = 'date';
  String _filterStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsProvider = context.watch<NewsProvider>();
    var articles = List.from(newsProvider.allArticles);

    // Filter
    if (_filterStatus == 'published') {
      articles = articles.where((a) => a.isPublished).toList();
    } else if (_filterStatus == 'draft') {
      articles = articles.where((a) => !a.isPublished).toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      articles = articles
          .where((a) => a.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Sort
    if (_sortBy == 'date') {
      articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (_sortBy == 'views') {
      articles.sort((a, b) => b.views.compareTo(a.views));
    } else if (_sortBy == 'title') {
      articles.sort((a, b) => a.title.compareTo(b.title));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manage Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.adminCreateArticle);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'Search articles...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Status filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _filterStatus,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Status')),
                          DropdownMenuItem(value: 'published', child: Text('Published')),
                          DropdownMenuItem(value: 'draft', child: Text('Draft')),
                        ],
                        onChanged: (v) => setState(() => _filterStatus = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sort
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _sortBy,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'date', child: Text('Sort: Date')),
                          DropdownMenuItem(value: 'views', child: Text('Sort: Views')),
                          DropdownMenuItem(value: 'title', child: Text('Sort: Title')),
                        ],
                        onChanged: (v) => setState(() => _sortBy = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Article list
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final article = articles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AdaptiveImage(
                        imagePath: article.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorWidget: Container(
                          width: 60,
                          height: 60,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.image),
                        ),
                      ),
                    ),
                    title: Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: article.isPublished
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                article.isPublished ? 'Published' : 'Draft',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: article.isPublished
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${formatNumber(article.views)} views',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              TimeAgo.format(article.publishedAt),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            Navigator.pushNamed(
                              context,
                              AppRoutes.adminEditArticle,
                              arguments: article,
                            );
                            break;
                          case 'toggle':
                            newsProvider.toggleArticlePublish(article.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  article.isPublished
                                      ? 'Article unpublished'
                                      : 'Article published',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            break;
                          case 'delete':
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete Article'),
                                content: const Text(
                                    'Are you sure you want to delete this article?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      newsProvider.deleteArticle(article.id);
                                      Navigator.pop(ctx);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(
                          value: 'toggle',
                          child: Text(article.isPublished
                              ? 'Unpublish'
                              : 'Publish'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child:
                              Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
