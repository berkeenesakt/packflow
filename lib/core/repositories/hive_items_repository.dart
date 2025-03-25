import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packpal/core/repositories/items_repository.dart';
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
