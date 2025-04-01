import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packpal/core/providers/theme_provider.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.navigation_titles_settings.tr()),
      ),
      body: ListView(
        children: [
          // Appearance section
          _buildSectionHeader(context, LocaleKeys.settings_appearance.tr()),
          _buildThemeSettingItem(
            context,
            themeProvider,
          ),

          // Language section
          _buildSectionHeader(context, LocaleKeys.settings_language.tr()),
          _buildSettingItem(
            context,
            icon: Icons.language_outlined,
            title: LocaleKeys.settings_app_language.tr(),
            subtitle: context.locale.languageCode == 'en' ? 'English' : 'Türkçe',
            onTap: () {
              _showLanguageSelectionDialog(context);
            },
          ),

          // Notifications section
          _buildSectionHeader(context, LocaleKeys.settings_notifications.tr()),
          _buildSwitchItem(
            context,
            icon: Icons.notifications_outlined,
            title: LocaleKeys.settings_trip_reminders.tr(),
            subtitle: LocaleKeys.settings_trip_reminders_desc.tr(),
            value: false,
            onChanged: (value) {
              // TODO: Implement notification toggle
            },
          ),

          // About section
          _buildSectionHeader(context, LocaleKeys.settings_about.tr()),
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: LocaleKeys.settings_version.tr(),
            subtitle: '1.0.0',
            onTap: () {
              // Show version details
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: LocaleKeys.settings_privacy.tr(),
            onTap: () {
              // Open privacy policy
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.feedback_outlined,
            title: LocaleKeys.settings_feedback.tr(),
            onTap: () {
              // Open feedback form
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettingItem(BuildContext context, ThemeProvider themeProvider) {
    String themeText;
    switch (themeProvider.themeMode) {
      case ThemeMode.system:
        themeText = LocaleKeys.settings_theme_system.tr();
        break;
      case ThemeMode.light:
        themeText = LocaleKeys.settings_theme_light.tr();
        break;
      case ThemeMode.dark:
        themeText = LocaleKeys.settings_theme_dark.tr();
        break;
    }

    return ListTile(
      leading: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.primary),
      title: Text(LocaleKeys.settings_theme.tr()),
      subtitle: Text(themeText),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showThemeSelectionDialog(context, themeProvider);
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_select_theme.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(LocaleKeys.settings_theme_system.tr()),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_theme_light.tr()),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.settings_theme_dark.tr()),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.general_cancel.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showLanguageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_select_language.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Türkçe'),
              leading: Radio<String>(
                value: 'tr',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('tr'));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(LocaleKeys.general_cancel.tr()),
          ),
        ],
      ),
    );
  }
}
