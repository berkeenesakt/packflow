import 'package:gen/gen.dart';

abstract class CategoriesRepository {
  Future<List<PackingCategory>> getCategories();
  Future<void> addCategory(PackingCategory category);
  Future<void> updateCategory(PackingCategory category);
  Future<void> deleteCategory(String categoryId);
}
