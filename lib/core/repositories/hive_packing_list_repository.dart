import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';

class HivePackingListRepository implements PackingListRepository {
  HivePackingListRepository({
    Box<Map<dynamic, dynamic>>? packingListBox,
  }) : _packingListBox = packingListBox ?? Hive.box<Map<dynamic, dynamic>>('packing_lists');

  final Box<Map<dynamic, dynamic>> _packingListBox;

  @override
  Future<List<PackingList>> getAllPackingLists() async {
    return _packingListBox.values.map((json) => PackingList.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  @override
  Future<PackingList?> getPackingList(String id) async {
    final json = _packingListBox.get(id);
    if (json == null) return null;
    return PackingList.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<void> createPackingList(PackingList packingList) async {
    await _packingListBox.put(packingList.id, packingList.toJson());
  }

  @override
  Future<void> updatePackingList(PackingList packingList) async {
    await _packingListBox.put(packingList.id, packingList.toJson());
  }

  @override
  Future<void> deletePackingList(String id) async {
    await _packingListBox.delete(id);
  }

  @override
  Future<void> addCategory(String packingListId, PackingCategory category) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedList = packingList.copyWith(
      categories: [...packingList.categories, category],
    );
    await updatePackingList(updatedList);
  }

  @override
  Future<void> updateCategory(String packingListId, PackingCategory category) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedCategories = packingList.categories.map((c) {
      return c.id == category.id ? category : c;
    }).toList();

    final updatedList = packingList.copyWith(categories: updatedCategories);
    await updatePackingList(updatedList);
  }

  @override
  Future<void> deleteCategory(String packingListId, String categoryId) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedCategories = packingList.categories.where((c) => c.id != categoryId).toList();
    final updatedList = packingList.copyWith(categories: updatedCategories);
    await updatePackingList(updatedList);
  }

  @override
  Future<void> addItem(String packingListId, String categoryId, PackingItem item) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedCategories = packingList.categories.map((category) {
      if (category.id == categoryId) {
        return category.copyWith(items: [...category.items, item]);
      }
      return category;
    }).toList();

    final updatedList = packingList.copyWith(categories: updatedCategories);
    await updatePackingList(updatedList);
  }

  @override
  Future<void> updateItem(String packingListId, String categoryId, PackingItem item) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedCategories = packingList.categories.map((category) {
      if (category.id == categoryId) {
        final updatedItems = category.items.map((i) => i.id == item.id ? item : i).toList();
        return category.copyWith(items: updatedItems);
      }
      return category;
    }).toList();

    final updatedList = packingList.copyWith(categories: updatedCategories);
    await updatePackingList(updatedList);
  }

  @override
  Future<void> deleteItem(String packingListId, String categoryId, String itemId) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedCategories = packingList.categories.map((category) {
      if (category.id == categoryId) {
        final updatedItems = category.items.where((item) => item.id != itemId).toList();
        return category.copyWith(items: updatedItems);
      }
      return category;
    }).toList();

    final updatedList = packingList.copyWith(categories: updatedCategories);
    await updatePackingList(updatedList);
  }

  @override
  Future<void> toggleItem(String packingListId, String categoryId, String itemId) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedCategories = packingList.categories.map((category) {
      if (category.id == categoryId) {
        final updatedItems = category.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(isChecked: !item.isChecked);
          }
          return item;
        }).toList();
        return category.copyWith(items: updatedItems);
      }
      return category;
    }).toList();

    final updatedList = packingList.copyWith(categories: updatedCategories);
    await updatePackingList(updatedList);
  }
}
