import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import '../../services/mock_data.dart';
import '../../utils/routes.dart';
import '../../widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  bool _hasSearched = false;
  String _sortBy = 'relevance';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    final provider = context.read<NewsProvider>();
    provider.addRecentSearch(query.trim());
    provider.search(query.trim());
    setState(() => _hasSearched = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsProvider = context.watch<NewsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                onSubmitted: _performSearch,
                onChanged: (value) {
                  if (value.isEmpty) {
                    newsProvider.search('');
                    setState(() => _hasSearched = false);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search news, topics, sources...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            newsProvider.search('');
                            setState(() => _hasSearched = false);
                          },
                        )
                      : null,
                ),
              ),
            ),

            // Content
            Expanded(
              child: _hasSearched
                  ? _buildSearchResults(context, theme, newsProvider)
                  : _buildSuggestions(context, theme, newsProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(
      BuildContext context, ThemeData theme, NewsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (provider.recentSearches.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Recent Searches', style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: () => provider.clearRecentSearches(),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: provider.recentSearches.map((search) {
                return ActionChip(
                  avatar: const Icon(Icons.history, size: 16),
                  label: Text(search),
                  onPressed: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                );
              }).toList(),
            ),
          ],

          // Trending
          const SizedBox(height: 24),
          Text('Trending Topics', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockData.trendingTopics.map((topic) {
              return ActionChip(
                avatar: const Icon(Icons.trending_up, size: 16, color: Colors.red),
                label: Text(topic),
                onPressed: () {
                  _searchController.text = topic;
                  _performSearch(topic);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
      BuildContext context, ThemeData theme, NewsProvider provider) {
    return Column(
      children: [
        // Filter bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${provider.articles.length} results',
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              PopupMenuButton<String>(
                initialValue: _sortBy,
                onSelected: (value) {
                  setState(() => _sortBy = value);
                },
                child: Row(
                  children: [
                    const Icon(Icons.sort, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Sort: ${_sortBy[0].toUpperCase()}${_sortBy.substring(1)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'relevance', child: Text('Relevance')),
                  const PopupMenuItem(value: 'date', child: Text('Date')),
                  const PopupMenuItem(value: 'source', child: Text('Source')),
                ],
              ),
            ],
          ),
        ),
        // Results
        Expanded(
          child: provider.articles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 60,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try different keywords',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: provider.articles.length,
                  itemBuilder: (context, index) {
                    return NewsCard(
                      article: provider.articles[index],
                      isCompact: true,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.articleDetail,
                          arguments: provider.articles[index],
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
