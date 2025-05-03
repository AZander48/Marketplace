import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ApiService _apiService = ApiService();
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('language', _selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile Settings'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile/edit');
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Location Settings'),
                onTap: () {
                  Navigator.pushNamed(context, '/settings/location');
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification Settings'),
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                      _saveSettings();
                    });
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'App Settings',
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                      _saveSettings();
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: ['English', 'Spanish', 'French'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                        _saveSettings();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            title: 'Privacy & Security',
            children: [
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Privacy Settings'),
                onTap: () {
                  Navigator.pushNamed(context, '/settings/privacy');
                },
              ),
              ListTile(
                leading: const Icon(Icons.password),
                title: const Text('Change Password'),
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Blocked Users'),
                onTap: () {
                  Navigator.pushNamed(context, '/settings/blocked-users');
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Support',
            children: [
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help Center'),
                onTap: () {
                  // TODO: Implement help center
                },
              ),
              ListTile(
                leading: const Icon(Icons.contact_support),
                title: const Text('Contact Support'),
                onTap: () {
                  // TODO: Implement contact support
                },
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Terms of Service'),
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Data & Storage',
            children: [
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Clear Cache'),
                onTap: _clearCache,
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download My Data'),
                onTap: () {
                  // TODO: Implement data download
                },
              ),
            ],
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return _buildSection(
                title: 'Account Actions',
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      await authProvider.logout();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      _showDeleteAccountDialog();
                    },
                  ),
                ],
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Future<void> _showChangePasswordDialog() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement password change
              Navigator.pop(context);
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Implement cache clearing
      await Future.delayed(const Duration(seconds: 1)); // Simulated delay
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing cache: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
} 