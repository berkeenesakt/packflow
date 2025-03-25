import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';

class HivePackingListRepository implements PackingListRepository {
  HivePackingListRepository({
    Box<PackingList>? packingListBox,
  }) : _packingListBox = packingListBox ?? Hive.box<PackingList>('packing_lists');

  final Box<PackingList> _packingListBox;

  @override
  Future<List<PackingList>> getAllPackingLists() async {
    return _packingListBox.values.toList();
  }

  @override
  Future<PackingList?> getPackingList(String id) async {
    final json = _packingListBox.get(id);
    if (json == null) return null;
    return json;
  }

  @override
  Future<void> createPackingList(PackingList packingList) async {
    await _packingListBox.put(packingList.id, packingList);
  }

  @override
  Future<void> updatePackingList(PackingList packingList) async {
    await _packingListBox.put(packingList.id, packingList);
  }

  @override
  Future<void> deletePackingList(String id) async {
    await _packingListBox.delete(id);
  }

  @override
  Future<void> addItem(String packingListId, PackingItem item) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;

    final updatedList = packingList.copyWith(
      items: [...packingList.items, item],
    );
    await updatePackingList(updatedList);
  }

  @override
  Future<void> deleteItem(String packingListId, String itemId) async {
    final packingList = await getPackingList(packingListId);
    if (packingList == null) return;
    final updatedList = packingList.copyWith(items: packingList.items.where((item) => item.id != itemId).toList());
    await updatePackingList(updatedList);
  }

  @override
  Future<void> toggleItem(String packingListId, String itemId) async {
    final packingList = await getPackingList(packingListId);
    final item = packingList?.items.firstWhere((item) => item.id == itemId);
    if (packingList == null || item == null) return;
    if (packingList.checkedItems.contains(item)) {
      packingList.checkedItems.remove(item);
    } else {
      packingList.checkedItems.add(item);
    }
    final updatedList = packingList.copyWith(checkedItems: packingList.checkedItems);
    await updatePackingList(updatedList);
  }
}
