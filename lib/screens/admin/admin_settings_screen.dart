import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/routes.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _breakingAlerts = true;
  bool _autoPublish = false;
  bool _requireApproval = true;
  String _defaultLanguage = 'English';
  int _articlesPerPage = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(theme, 'Appearance'),
          _settingCard(
            theme,
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Toggle dark theme'),
                secondary: const Icon(Icons.dark_mode),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(theme, 'Notifications'),
          _settingCard(
            theme,
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive push notifications'),
                secondary: const Icon(Icons.notifications),
                value: _pushNotifications,
                onChanged: (v) => setState(() => _pushNotifications = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Email Notifications'),
                subtitle: const Text('Receive email digests'),
                secondary: const Icon(Icons.email),
                value: _emailNotifications,
                onChanged: (v) =>
                    setState(() => _emailNotifications = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Breaking News Alerts'),
                subtitle: const Text('Alert editors for breaking news'),
                secondary: const Icon(Icons.warning_amber),
                value: _breakingAlerts,
                onChanged: (v) => setState(() => _breakingAlerts = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(theme, 'Content Settings'),
          _settingCard(
            theme,
            children: [
              SwitchListTile(
                title: const Text('Auto-Publish'),
                subtitle: const Text('Publish articles immediately'),
                secondary: const Icon(Icons.publish),
                value: _autoPublish,
                onChanged: (v) => setState(() => _autoPublish = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Require Approval'),
                subtitle: const Text('Articles need editor approval'),
                secondary: const Icon(Icons.approval),
                value: _requireApproval,
                onChanged: (v) => setState(() => _requireApproval = v),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.format_list_numbered),
                title: const Text('Articles per Page'),
                subtitle: Text('$_articlesPerPage articles'),
                trailing: DropdownButton<int>(
                  value: _articlesPerPage,
                  underline: const SizedBox.shrink(),
                  items: [10, 20, 30, 50].map((v) {
                    return DropdownMenuItem(
                        value: v, child: Text('$v'));
                  }).toList(),
                  onChanged: (v) =>
                      setState(() => _articlesPerPage = v ?? 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(theme, 'General'),
          _settingCard(
            theme,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Default Language'),
                subtitle: Text(_defaultLanguage),
                trailing: DropdownButton<String>(
                  value: _defaultLanguage,
                  underline: const SizedBox.shrink(),
                  items: ['English', 'Spanish', 'French', 'German']
                      .map((l) => DropdownMenuItem(
                          value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _defaultLanguage = v ?? 'English'),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Clear Cache'),
                subtitle: const Text('Free up storage space'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared!')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0 (Build 1)'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(theme, 'Account'),
          _settingCard(
            theme,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text(
                          'Are you sure you want to logout from admin panel?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthProvider>().logout();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AppRoutes.login, (route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _settingCard(ThemeData theme, {required List<Widget> children}) {
    return Container(
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
      child: Column(children: children),
    );
  }
}
