import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packpal/core/repositories/categories_repository.dart';
import 'package:packpal/core/repositories/items_repository.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:uuid/uuid.dart';

class CreatePackingListProvider extends ChangeNotifier {
  CreatePackingListProvider({
    required this.repository,
    required this.itemsRepository,
    required this.categoriesRepository,
    this.packingList,
  }) {
    if (isEditing) {
      nameController.text = packingList!.name;
      descriptionController.text = packingList!.description ?? '';
      _startDate = packingList!.departureDate;
      _endDate = packingList!.returnDate;
      _selectedItems = [...packingList!.items];
    }
    loadCategories().then((_) => loadItems());
  }

  final PackingListRepository repository;
  final ItemsRepository itemsRepository;
  final CategoriesRepository categoriesRepository;
  final PackingList? packingList;

  bool isLoading = true;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<PackingItem> _items = [];
  List<PackingCategory> _categories = [];
  List<PackingItem> _selectedItems = [];
  PackingCategory? _selectedCategory;

  bool get isEditing => packingList != null;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<PackingItem> get items => _items;
  List<PackingCategory> get categories => _categories;
  List<PackingItem> get selectedItems => _selectedItems;
  PackingCategory? get selectedCategory => _selectedCategory;

  Future<void> setSelectedCategory(PackingCategory? category) async {
    _selectedCategory = category;
    if (category != null) {
      _items = await itemsRepository.getItemsByCategory(category.id);
    } else {
      _items = [];
    }
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await categoriesRepository.getCategories();
    if (_categories.isNotEmpty && _selectedCategory == null) {
      _selectedCategory = _categories.first;
    }
    notifyListeners();
  }

  Future<void> loadItems() async {
    if (_selectedCategory != null) {
      _items = await itemsRepository.getItemsByCategory(_selectedCategory!.id);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String itemName) async {
    final newItem = await itemsRepository.addItem(itemName, _selectedCategory!.id);
    _selectedItems.add(newItem);
    notifyListeners();
  }

  void toggleItem(PackingItem item) {
    final index = _selectedItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _selectedItems.removeAt(index);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  void deleteItem(PackingItem item) {
    itemsRepository.deleteItem(item.id);
    _selectedItems.remove(item);
    _items.remove(item);
    notifyListeners();
  }

  bool isItemSelected(String itemId) {
    return _selectedItems.any((item) => item.id == itemId);
  }

  List<PackingItem> getItemsByCategory(String categoryId) {
    // For simplicity, since we've removed predefined items,
    // just return all items for now
    return _items;
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
  }

  void clearDateRange() {
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  Future<bool> save() async {
    notifyListeners();

    try {
      final packingListData = PackingList(
        id: isEditing ? packingList!.id : const Uuid().v4(),
        name: nameController.text,
        description: descriptionController.text.isEmpty ? null : descriptionController.text,
        createdAt: isEditing ? packingList!.createdAt : DateTime.now(),
        departureDate: _startDate,
        returnDate: _endDate,
        items: _selectedItems,
      );

      if (isEditing) {
        await repository.updatePackingList(packingListData);
      } else {
        await repository.createPackingList(packingListData);
      }

      notifyListeners();
      return true;
    } on Exception {
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
