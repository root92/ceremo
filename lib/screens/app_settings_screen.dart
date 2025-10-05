import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  PackageInfo? _packageInfo;
  bool _autoSync = true;
  bool _offlineMode = false;
  bool _biometricAuth = false;
  String _fontSize = 'medium';
  String _syncFrequency = 'hourly';
  
  // Notification settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _marketingEmails = false;
  bool _securityAlerts = true;
  bool _projectUpdates = true;
  bool _contributionReminders = true;
  bool _expenseAlerts = true;
  bool _estimateNotifications = true;
  bool _organizationInvites = true;
  bool _weeklyDigest = false;
  bool _monthlyReport = true;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = packageInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appSettings),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.generalSettings,
              children: [
                _buildSwitchTile(
                  context,
                  icon: Icons.sync,
                  title: AppLocalizations.of(context)!.autoSync,
                  subtitle: 'Automatically sync data with server',
                  value: _autoSync,
                  onChanged: (value) {
                    setState(() {
                      _autoSync = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.offline_bolt,
                  title: AppLocalizations.of(context)!.offlineMode,
                  subtitle: 'Work without internet connection',
                  value: _offlineMode,
                  onChanged: (value) {
                    setState(() {
                      _offlineMode = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.fingerprint,
                  title: AppLocalizations.of(context)!.biometricAuth,
                  subtitle: 'Use fingerprint or face recognition',
                  value: _biometricAuth,
                  onChanged: (value) {
                    setState(() {
                      _biometricAuth = value;
                    });
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.schedule,
                  title: AppLocalizations.of(context)!.syncFrequency,
                  subtitle: _getSyncFrequencyLabel(),
                  onTap: () => _showSyncFrequencyDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Display Settings
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.displaySettings,
              children: [
                _buildListTile(
                  context,
                  icon: Icons.palette,
                  title: AppLocalizations.of(context)!.theme,
                  subtitle: _getCurrentThemeName(context),
                  onTap: () => _showThemeDialog(context),
                ),
                _buildListTile(
                  context,
                  icon: Icons.language,
                  title: AppLocalizations.of(context)!.language,
                  subtitle: _getCurrentLanguageName(context),
                  onTap: () => _showLanguageDialog(context),
                ),
                _buildListTile(
                  context,
                  icon: Icons.text_fields,
                  title: AppLocalizations.of(context)!.fontSize,
                  subtitle: _getFontSizeLabel(),
                  onTap: () => _showFontSizeDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Notification Settings
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.notificationSettings,
              children: [
                _buildSwitchTile(
                  context,
                  icon: Icons.notifications,
                  title: AppLocalizations.of(context)!.pushNotifications,
                  subtitle: 'Receive push notifications',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.email,
                  title: AppLocalizations.of(context)!.emailNotifications,
                  subtitle: 'Receive email notifications',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.sms,
                  title: AppLocalizations.of(context)!.smsNotifications,
                  subtitle: 'Receive SMS notifications',
                  value: _smsNotifications,
                  onChanged: (value) {
                    setState(() {
                      _smsNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.campaign,
                  title: AppLocalizations.of(context)!.marketingEmails,
                  subtitle: 'Receive marketing emails',
                  value: _marketingEmails,
                  onChanged: (value) {
                    setState(() {
                      _marketingEmails = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.security,
                  title: AppLocalizations.of(context)!.securityAlerts,
                  subtitle: 'Security and login alerts',
                  value: _securityAlerts,
                  onChanged: (value) {
                    setState(() {
                      _securityAlerts = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.work,
                  title: AppLocalizations.of(context)!.projectUpdates,
                  subtitle: 'Project updates and changes',
                  value: _projectUpdates,
                  onChanged: (value) {
                    setState(() {
                      _projectUpdates = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.attach_money,
                  title: AppLocalizations.of(context)!.contributionReminders,
                  subtitle: 'Contribution reminders',
                  value: _contributionReminders,
                  onChanged: (value) {
                    setState(() {
                      _contributionReminders = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.receipt,
                  title: AppLocalizations.of(context)!.expenseAlerts,
                  subtitle: 'Expense alerts and notifications',
                  value: _expenseAlerts,
                  onChanged: (value) {
                    setState(() {
                      _expenseAlerts = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.analytics,
                  title: AppLocalizations.of(context)!.estimateNotifications,
                  subtitle: 'Estimate notifications',
                  value: _estimateNotifications,
                  onChanged: (value) {
                    setState(() {
                      _estimateNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.group,
                  title: AppLocalizations.of(context)!.organizationInvites,
                  subtitle: 'Organization invitations',
                  value: _organizationInvites,
                  onChanged: (value) {
                    setState(() {
                      _organizationInvites = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.calendar_today,
                  title: AppLocalizations.of(context)!.weeklyDigest,
                  subtitle: 'Weekly summary emails',
                  value: _weeklyDigest,
                  onChanged: (value) {
                    setState(() {
                      _weeklyDigest = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  icon: Icons.assessment,
                  title: AppLocalizations.of(context)!.monthlyReport,
                  subtitle: 'Monthly reports',
                  value: _monthlyReport,
                  onChanged: (value) {
                    setState(() {
                      _monthlyReport = value;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Data & Storage
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.dataUsage,
              children: [
                _buildInfoTile(
                  context,
                  icon: Icons.storage,
                  title: AppLocalizations.of(context)!.cacheSize,
                  value: '12.5 MB',
                ),
                _buildActionTile(
                  context,
                  icon: Icons.clear_all,
                  title: AppLocalizations.of(context)!.clearCache,
                  subtitle: 'Free up storage space',
                  onTap: () => _showClearCacheDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // About App
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.aboutApp,
              children: [
                if (_packageInfo != null) ...[
                  _buildInfoTile(
                    context,
                    icon: Icons.info,
                    title: AppLocalizations.of(context)!.version,
                    value: _packageInfo!.version,
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.build,
                    title: AppLocalizations.of(context)!.buildNumber,
                    value: _packageInfo!.buildNumber,
                  ),
                ],
                _buildActionTile(
                  context,
                  icon: Icons.star,
                  title: AppLocalizations.of(context)!.rateApp,
                  subtitle: 'Rate us on the App Store',
                  onTap: () {
                    // TODO: Implement rate app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rate app functionality coming soon')),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.share,
                  title: AppLocalizations.of(context)!.shareApp,
                  subtitle: 'Share with friends',
                  onTap: () {
                    // TODO: Implement share app
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share app functionality coming soon')),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.feedback,
                  title: AppLocalizations.of(context)!.feedback,
                  subtitle: 'Send us your feedback',
                  onTap: () {
                    // TODO: Implement feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Feedback functionality coming soon')),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.help,
                  title: AppLocalizations.of(context)!.support,
                  subtitle: 'Get help and support',
                  onTap: () {
                    // TODO: Implement support
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support functionality coming soon')),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.privacy_tip,
                  title: AppLocalizations.of(context)!.privacyPolicy,
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    // TODO: Implement privacy policy
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Privacy policy functionality coming soon')),
                    );
                  },
                ),
                _buildActionTile(
                  context,
                  icon: Icons.description,
                  title: AppLocalizations.of(context)!.termsOfService,
                  subtitle: 'Read our terms of service',
                  onTap: () {
                    // TODO: Implement terms of service
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Terms of service functionality coming soon')),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _getCurrentThemeName(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    switch (themeProvider.themeMode) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.systemTheme;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.lightTheme;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.darkTheme;
    }
  }

  String _getCurrentLanguageName(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    switch (localeProvider.locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  String _getSyncFrequencyLabel() {
    switch (_syncFrequency) {
      case 'realtime':
        return 'Real-time';
      case 'hourly':
        return 'Every hour';
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      default:
        return 'Every hour';
    }
  }

  String _getFontSizeLabel() {
    switch (_fontSize) {
      case 'small':
        return AppLocalizations.of(context)!.small;
      case 'medium':
        return AppLocalizations.of(context)!.medium;
      case 'large':
        return AppLocalizations.of(context)!.large;
      case 'extraLarge':
        return AppLocalizations.of(context)!.extraLarge;
      default:
        return AppLocalizations.of(context)!.medium;
    }
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
                  title: Text(AppLocalizations.of(context)!.systemTheme),
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      themeProvider.setThemeMode(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: Text(AppLocalizations.of(context)!.lightTheme),
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
                  title: Text(AppLocalizations.of(context)!.darkTheme),
                  value: ThemeMode.dark,
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
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.fontSize),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.small),
              value: 'small',
              groupValue: _fontSize,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _fontSize = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.medium),
              value: 'medium',
              groupValue: _fontSize,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _fontSize = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.large),
              value: 'large',
              groupValue: _fontSize,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _fontSize = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(AppLocalizations.of(context)!.extraLarge),
              value: 'extraLarge',
              groupValue: _fontSize,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _fontSize = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSyncFrequencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.syncFrequency),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Real-time'),
              value: 'realtime',
              groupValue: _syncFrequency,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _syncFrequency = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Every hour'),
              value: 'hourly',
              groupValue: _syncFrequency,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _syncFrequency = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Daily'),
              value: 'daily',
              groupValue: _syncFrequency,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _syncFrequency = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('Weekly'),
              value: 'weekly',
              groupValue: _syncFrequency,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _syncFrequency = value;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearCache),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: Text(AppLocalizations.of(context)!.clearCache),
          ),
        ],
      ),
    );
  }
}
