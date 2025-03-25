import 'package:gen/gen.dart';

abstract class PackingListRepository {
  Future<List<PackingList>> getAllPackingLists();
  Future<PackingList?> getPackingList(String id);
  Future<void> createPackingList(PackingList packingList);
  Future<void> updatePackingList(PackingList packingList);
  Future<void> deletePackingList(String id);

  Future<void> addItem(String packingListId, PackingItem item);
  Future<void> deleteItem(String packingListId, String itemId);
  Future<void> toggleItem(String packingListId, String itemId);
}
