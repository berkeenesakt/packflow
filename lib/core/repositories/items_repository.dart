import 'package:gen/gen.dart';

abstract class ItemsRepository {
  Future<List<PackingItem>> getItems();
  Future<List<PackingItem>> getItemsByCategory(String categoryId);
  Future<void> updateItem(PackingItem item);
  Future<void> deleteItem(String itemId);
  Future<PackingItem> addItem(String itemName, String categoryId);
}
