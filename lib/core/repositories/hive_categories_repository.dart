import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packflow/core/repositories/categories_repository.dart';
import 'package:packflow/core/repositories/hive_items_repository.dart';

class HiveCategoriesRepository implements CategoriesRepository {
  @override
  Future<List<PackingCategory>> getCategories() async {
    final categories = Hive.box<PackingCategory>('categories').values.toList()
      ..sort((a, b) {
        // Sort categories by createdAt date, with null dates first, then oldest to newest
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return -1; // null dates are placed first
        if (b.createdAt == null) return 1;
        return a.createdAt!.compareTo(b.createdAt!); // Oldest first (ascending order)
      });
    return categories;
  }

  @override
  Future<void> updateCategory(PackingCategory category) async {
    await Hive.box<PackingCategory>('categories').put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    // Remove all items associated with the category
    final itemsRepository = HiveItemsRepository();
    final items = await itemsRepository.getItemsByCategory(categoryId);
    for (final item in items) {
      await itemsRepository.deleteItem(item.id);
    }
    // Delete the category itself
    await Hive.box<PackingCategory>('categories').delete(categoryId);
  }

  @override
  Future<void> addCategory(PackingCategory category) async {
    // Ensure new categories have a creation timestamp
    final categoryWithTimestamp = category.createdAt == null
        ? PackingCategory(
            id: category.id,
            name: category.name,
            createdAt: DateTime.now(),
          )
        : category;

    await Hive.box<PackingCategory>('categories').put(categoryWithTimestamp.id, categoryWithTimestamp);
  }
}
