import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packflow/core/exceptions/item_exceptions.dart';
import 'package:packflow/core/repositories/items_repository.dart';
import 'package:uuid/uuid.dart';

class HiveItemsRepository implements ItemsRepository {
  @override
  Future<List<PackingItem>> getItems() async {
    return Hive.box<PackingItem>('packing_items').values.toList();
  }

  @override
  Future<void> updateItem(PackingItem item) async {
    await Hive.box<PackingItem>('packing_items').put(item.id, item);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    //Scan for all packing lists that contain the item
    final packingLists = Hive.box<PackingList>('packing_lists')
        .values
        .where((list) => list.items.any((item) => item.id == itemId))
        .toList();
    for (final list in packingLists) {
      list.items.removeWhere((item) => item.id == itemId);
      list.checkedItems.removeWhere((item) => item.id == itemId);
      await Hive.box<PackingList>('packing_lists').put(list.id, list);
    }
    await Hive.box<PackingItem>('packing_items').delete(itemId);
  }

  @override
  Future<PackingItem> addItem(String itemName, String categoryId) async {
    final item = PackingItem(
      id: const Uuid().v4(),
      name: itemName,
      categoryId: categoryId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final itemExists =
        Hive.box<PackingItem>('packing_items').values.any((i) => i.name == itemName && i.categoryId == categoryId);
    if (itemExists) {
      throw ItemExistsException();
    }
    await Hive.box<PackingItem>('packing_items').put(item.id, item);
    return item;
  }

  @override
  Future<List<PackingItem>> getItemsByCategory(String categoryId) async {
    final items = Hive.box<PackingItem>('packing_items').values.where((item) => item.categoryId == categoryId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return items.reversed.toList();
  }
}
