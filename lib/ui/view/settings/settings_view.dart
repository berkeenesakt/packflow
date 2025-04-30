import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packflow/core/enums/locales.dart';
import 'package:packflow/core/providers/app_settings_provider.dart';
import 'package:packflow/core/services/notification_service.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final NotificationService _notificationService = NotificationService();
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.navigation_titles_settings.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
      body: ListView(
        children: [
          // Appearance section
          _buildSectionHeader(context, LocaleKeys.settings_appearance.tr()),
          _buildThemeSettingItem(
            context,
            appSettings,
          ),

          // Language section
          _buildSectionHeader(context, LocaleKeys.settings_language.tr()),
          _buildLanguageSettingItem(
            context,
            appSettings,
          ),

          // Notifications section
          _buildSectionHeader(context, LocaleKeys.settings_notifications.tr()),
          _buildSwitchItem(
            context,
            icon: Icons.notifications_outlined,
            title: LocaleKeys.settings_trip_reminders.tr(),
            subtitle: LocaleKeys.settings_trip_reminders_desc.tr(),
            value: _notificationsEnabled,
            onChanged: (value) async {
              setState(() {
                _notificationsEnabled = value;
              });

              if (value) {
                // Request permissions if enabling notifications
                await _notificationService.requestPermissions();
              } else {
                // Cancel all notifications if disabling
                await _notificationService.cancelAllNotifications();
              }
            },
          ),

          // About section
          _buildSectionHeader(context, LocaleKeys.settings_about.tr()),
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: LocaleKeys.settings_version.tr(),
            subtitle: '1.0.2',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'PackFlow',
                applicationVersion: '1.0.2',
                applicationIcon: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    Assets.icons.appIcon.path,
                    package: 'gen',
                    width: 64,
                    height: 64,
                  ),
                ),
                applicationLegalese: '© 2025 Berke Enes Aktumen. All rights reserved.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSettingItem(BuildContext context, AppSettingsProvider appSettings) {
    String themeText;
    switch (appSettings.themeMode) {
      case ThemeMode.system:
        themeText = LocaleKeys.settings_theme_system.tr();
      case ThemeMode.light:
        themeText = LocaleKeys.settings_theme_light.tr();
      case ThemeMode.dark:
        themeText = LocaleKeys.settings_theme_dark.tr();
    }

    return ListTile(
      leading: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.primary),
      title: Text(LocaleKeys.settings_theme.tr()),
      subtitle: Text(themeText),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showThemeSelectionDialog(context, appSettings);
      },
    );
  }

  Widget _buildLanguageSettingItem(BuildContext context, AppSettingsProvider appSettings) {
    return ListTile(
      leading: Icon(Icons.language_outlined, color: Theme.of(context).colorScheme.primary),
      title: Text(LocaleKeys.settings_app_language.tr()),
      subtitle: Text(context.locale.languageCode == 'en' ? 'English' : 'Türkçe'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showLanguageSelectionDialog(context, appSettings);
      },
    );
  }

  void _showThemeSelectionDialog(BuildContext context, AppSettingsProvider appSettings) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_select_theme.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(LocaleKeys.settings_theme_system.tr()),
              value: ThemeMode.system,
              groupValue: appSettings.themeMode,
              onChanged: (value) {
                appSettings.setThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(LocaleKeys.settings_theme_light.tr()),
              value: ThemeMode.light,
              groupValue: appSettings.themeMode,
              onChanged: (value) {
                appSettings.setThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(LocaleKeys.settings_theme_dark.tr()),
              value: ThemeMode.dark,
              groupValue: appSettings.themeMode,
              onChanged: (value) {
                appSettings.setThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
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

  void _showLanguageSelectionDialog(BuildContext context, AppSettingsProvider appSettings) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.settings_select_language.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: context.locale.languageCode,
              onChanged: (value) {
                appSettings.setLocale(context, Locales.en.locale);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Türkçe'),
              value: 'tr',
              groupValue: context.locale.languageCode,
              onChanged: (value) {
                appSettings.setLocale(context, Locales.tr.locale);
                Navigator.pop(context);
              },
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
    required VoidCallback onTap,
    String? subtitle,
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
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
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
      onTap: () => onChanged(!value),
    );
  }
}
