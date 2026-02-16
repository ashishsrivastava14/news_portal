import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/news_provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _searchQuery = '';
  String _filter = 'all'; // all, active, blocked

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newsProvider = context.watch<NewsProvider>();
    List<AppUser> users = newsProvider.users;

    // Filter
    if (_filter == 'active') {
      users = users.where((u) => !u.isBlocked).toList();
    } else if (_filter == 'blocked') {
      users = users.where((u) => u.isBlocked).toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      users = users
          .where((u) =>
              u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              u.email.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Manage Users'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _filter = val),
            itemBuilder: (_) => [
              _popItem('all', 'All Users'),
              _popItem('active', 'Active'),
              _popItem('blocked', 'Blocked'),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${users.length} users',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                if (_filter != 'all')
                  Chip(
                    label: Text(_filter),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _filter = 'all'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: users.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No users found',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: users.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _UserCard(
                        user: user,
                        onToggleBlock: () {
                          newsProvider.toggleUserBlock(user.id);
                        },
                        onTap: () => _showUserDetails(context, user),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PopupMenuEntry<String> _popItem(String value, String text) =>
      PopupMenuItem(
          value: value,
          child: Row(
            children: [
              if (_filter == value) const Icon(Icons.check, size: 18),
              if (_filter == value) const SizedBox(width: 8),
              Text(text),
            ],
          ));

  void _showUserDetails(BuildContext context, AppUser user) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              const SizedBox(height: 16),
              Text(user.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(user.email, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              if (user.isAdmin)
                Chip(
                  label: const Text('Admin'),
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: Colors.blue),
                ),
              if (user.isBlocked)
                Chip(
                  label: const Text('Blocked'),
                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _stat('Articles Read', user.articlesRead.toString()),
                  _stat('Bookmarks', user.bookmarksCount.toString()),
                  _stat(
                    'Joined',
                    '${user.joinedAt.day}/${user.joinedAt.month}/${user.joinedAt.year}',
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onToggleBlock;
  final VoidCallback onTap;

  const _UserCard({
    required this.user,
    required this.onToggleBlock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            if (user.isAdmin)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.star, size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Text(user.name, style: theme.textTheme.titleSmall),
            const SizedBox(width: 8),
            if (user.isBlocked)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Blocked',
                    style: TextStyle(fontSize: 10, color: Colors.red)),
              ),
          ],
        ),
        subtitle: Text(user.email, style: theme.textTheme.bodySmall),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'block') onToggleBlock();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  Icon(
                    user.isBlocked ? Icons.check_circle : Icons.block,
                    size: 18,
                    color: user.isBlocked ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(user.isBlocked ? 'Unblock' : 'Block'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
