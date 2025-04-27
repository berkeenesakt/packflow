import 'package:gen/gen.dart';
import 'package:packflow/generated/locale_keys.g.dart';

/// Utility class for managing predefined categories
class PredefinedCategories {
  /// Get a list of default categories with translated names
  static List<PackingCategory> getDefaultCategories() {
    return const [
      PackingCategory(
        id: 'electronics',
        name: LocaleKeys.categories_electronics,
      ),
      PackingCategory(
        id: 'clothes',
        name: LocaleKeys.categories_clothes,
      ),
      PackingCategory(
        id: 'toiletries',
        name: LocaleKeys.categories_toiletries,
      ),
      PackingCategory(
        id: 'essentials',
        name: LocaleKeys.categories_essentials,
      ),
      PackingCategory(
        id: 'documents',
        name: LocaleKeys.categories_documents,
      ),
    ];
  }
}
