import 'package:gen/gen.dart';

abstract class PackingListRepository {
  Future<List<PackingList>> getAllPackingLists();
  Future<PackingList?> getPackingList(String id);
  Future<void> createPackingList(PackingList packingList);
  Future<void> updatePackingList(PackingList packingList);
  Future<void> deletePackingList(String id);

  Future<void> addCategory(String packingListId, PackingCategory category);
  Future<void> updateCategory(String packingListId, PackingCategory category);
  Future<void> deleteCategory(String packingListId, String categoryId);

  Future<void> addItem(String packingListId, String categoryId, PackingItem item);
  Future<void> updateItem(String packingListId, String categoryId, PackingItem item);
  Future<void> deleteItem(String packingListId, String categoryId, String itemId);
  Future<void> toggleItem(String packingListId, String categoryId, String itemId);
}
