import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/theme_toggle.dart';
import '../widgets/language_toggle.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        authProvider.user!['name'] ?? 'User',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.user!['email'] ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Profile Information
                _buildSection(
                  context,
                  title: AppLocalizations.of(context)!.personalInformation,
                  children: [
                    _buildInfoTile(
                      context,
                      icon: Icons.person_outline,
                      title: AppLocalizations.of(context)!.name,
                      value: authProvider.user!['name'] ?? 'N/A',
                    ),
                    _buildInfoTile(
                      context,
                      icon: Icons.email_outlined,
                      title: AppLocalizations.of(context)!.email,
                      value: authProvider.user!['email'] ?? 'N/A',
                    ),
                    if (authProvider.user!['role'] != null)
                      _buildInfoTile(
                        context,
                        icon: Icons.badge_outlined,
                        title: AppLocalizations.of(context)!.role,
                        value: authProvider.user!['role'] ?? 'N/A',
                      ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Location & Preferences
                if (authProvider.user!['country'] != null || authProvider.user!['currency'] != null)
                  _buildSection(
                    context,
                    title: AppLocalizations.of(context)!.preferences,
                    children: [
                      if (authProvider.user!['country'] != null)
                        _buildInfoTile(
                          context,
                          icon: Icons.location_on_outlined,
                          title: AppLocalizations.of(context)!.country,
                          value: authProvider.user!['country'] ?? 'N/A',
                        ),
                      if (authProvider.user!['currency'] != null)
                        _buildInfoTile(
                          context,
                          icon: Icons.attach_money,
                          title: AppLocalizations.of(context)!.currency,
                          value: authProvider.user!['currency'] ?? 'N/A',
                        ),
                    ],
                  ),
                
                const SizedBox(height: 16),
                
                // Settings
                _buildSection(
                  context,
                  title: AppLocalizations.of(context)!.settings,
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: Icons.palette_outlined,
                      title: AppLocalizations.of(context)!.theme,
                      subtitle: _getCurrentThemeName(context),
                      onTap: () {
                        _showThemeDialog(context);
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.language_outlined,
                      title: AppLocalizations.of(context)!.language,
                      subtitle: _getCurrentLanguageName(context),
                      onTap: () {
                        _showLanguageDialog(context);
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.notifications_outlined,
                      title: AppLocalizations.of(context)!.notifications,
                      subtitle: AppLocalizations.of(context)!.manageNotifications,
                      onTap: () {
                        // TODO: Navigate to notification settings
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Account Actions
                _buildSection(
                  context,
                  title: AppLocalizations.of(context)!.account,
                  children: [
                    _buildActionTile(
                      context,
                      icon: Icons.logout,
                      title: AppLocalizations.of(context)!.logout,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                      isDestructive: true,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive 
            ? Colors.red 
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }

  String _getCurrentThemeName(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    switch (themeProvider.themeMode) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.dark;
      case ThemeMode.system:
        return AppLocalizations.of(context)!.system;
    }
  }

  String _getCurrentLanguageName(BuildContext context) {
    final localeProvider = context.read<LocaleProvider>();
    final locale = localeProvider.locale;
    if (locale.languageCode == 'fr') {
      return 'Français';
    }
    return 'English';
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.theme),
        content: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.light),
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.dark),
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.system),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Consumer<LocaleProvider>(
          builder: (context, localeProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<Locale>(
                  title: const Text('English'),
                  value: const Locale('en'),
                  groupValue: localeProvider.locale,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RadioListTile<Locale>(
                  title: const Text('Français'),
                  value: const Locale('fr'),
                  groupValue: localeProvider.locale,
                  onChanged: (value) {
                    if (value != null) {
                      localeProvider.setLocale(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text(AppLocalizations.of(context)!.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }
}
