# Localization in PackFlow

PackFlow supports multiple languages using the `easy_localization` package. The app currently supports:

- English (en)
- Turkish (tr)

## Implementation Details

- **Translation Files**: JSON-based translation files are stored in `/assets/translations/` directory
- **Keys Structure**: Translations are organized hierarchically by feature areas:
  ```
  {
    "onboarding": { ... },
    "navigation_titles": { ... },
    "packing_list": { ... },
    "categories": { ... },
    "items": { ... },
    "home": { ... },
    "settings": { ... },
    "general": { ... },
    "notifications": { ... }
  }
  ```
- **Code Generation**: The app uses generated Dart classes (in `lib/generated/locale_keys.g.dart`) for type-safe access to translation keys
- **Language Selection**: Users can change the app language in Settings without restarting the app
- **Fallback Mechanism**: If a translation is missing in the selected language, the app falls back to English

## Usage Example

```dart
// In Dart code
Text(LocaleKeys.categories_all.tr()) // Translates to "All" in English

// Translations with parameters
Text(LocaleKeys.packing_list_error_saving.tr(args: ['creating'])) 
// Produces "Error creating packing list" in English
```

## Generating Localization Keys

After modifying translation files, regenerate the Dart localization keys with:

```bash
flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart
```

This command generates type-safe access to all translation keys in the `lib/generated/locale_keys.g.dart` file.

## Adding a New Language

To add support for a new language:

1. Create a new JSON file in the `/assets/translations/` directory with the appropriate language code (e.g., `fr.json` for French)
2. Copy the structure from the `en.json` file
3. Translate all strings to the new language
4. Add the new locale to the supported locales in the app initialization code
5. Update the `_showLanguageSelectionDialog` method in `lib/ui/view/settings/settings_view.dart` to include the new language option
6. Update the subtitle in the `_buildLanguageSettingItem` method to include the new language name

Example of app initialization with a new language:

```dart
EasyLocalization(
  supportedLocales: const [
    Locale('en'),
    Locale('tr'),
    Locale('fr'), // New language added here
  ],
  path: 'assets/translations',
  fallbackLocale: const Locale('en'),
  child: MyApp(),
)
```

Remember to update the settings view to allow users to select the new language:

```dart
// In settings_view.dart, update the _showLanguageSelectionDialog method:
void _showLanguageSelectionDialog(BuildContext context, AppSettingsProvider appSettings) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(LocaleKeys.settings_select_language.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Existing language options
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: context.locale.languageCode,
            onChanged: (value) async {
              // ... handling code
            },
          ),
          RadioListTile<String>(
            title: const Text('Türkçe'),
            value: 'tr',
            groupValue: context.locale.languageCode,
            onChanged: (value) async {
              // ... handling code
            },
          ),
          // Add new language option
          RadioListTile<String>(
            title: const Text('Français'),
            value: 'fr',
            groupValue: context.locale.languageCode,
            onChanged: (value) async {
              Navigator.pop(context);
              await appSettings.setLocale(context, Locales.fr.locale);
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      // ... rest of the dialog
    ),
  );
}
```

Also update the subtitle in the language setting tile to include the new language:

```dart
Widget _buildLanguageSettingItem(BuildContext context, AppSettingsProvider appSettings) {
  return ListTile(
    leading: Icon(Icons.language_outlined, color: Theme.of(context).colorScheme.primary),
    title: Text(LocaleKeys.settings_app_language.tr()),
    subtitle: Text(() {
      switch (context.locale.languageCode) {
        case 'en':
          return 'English';
        case 'tr':
          return 'Türkçe';
        case 'fr':
          return 'Français';
        default:
          return 'English';
      }
    }()),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {
      _showLanguageSelectionDialog(context, appSettings);
    },
  );
}