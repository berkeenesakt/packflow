import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packflow/core/repositories/categories_repository.dart';

class HiveCategoriesRepository implements CategoriesRepository {
  @override
  Future<List<PackingCategory>> getCategories() async {
    return Hive.box<PackingCategory>('categories').values.toList();
  }

  @override
  Future<void> addCategory(PackingCategory category) async {
    await Hive.box<PackingCategory>('categories').put(category.id, category);
  }

  @override
  Future<void> updateCategory(PackingCategory category) async {
    await Hive.box<PackingCategory>('categories').put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await Hive.box<PackingCategory>('categories').delete(categoryId);
  }
}
