import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packflow/core/repositories/categories_repository.dart';
import 'package:packflow/core/repositories/items_repository.dart';

class ItemsProvider extends ChangeNotifier {
  ItemsProvider({
    required this.itemsRepository,
    required this.categoriesRepository,
  }) {
    loadCategories().then((_) => loadItems());
  }

  final ItemsRepository itemsRepository;
  final CategoriesRepository categoriesRepository;

  bool isLoading = true;

  List<PackingItem> _items = [];
  List<PackingCategory> _categories = [];
  PackingCategory? _selectedCategory;

  List<PackingItem> get items => _items;
  List<PackingCategory> get categories => _categories;
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
    if (_selectedCategory == null) return;
    final newItem = await itemsRepository.addItem(itemName, _selectedCategory!.id);
    _items.add(newItem);
    notifyListeners();
  }

  void deleteItem(PackingItem item) {
    itemsRepository.deleteItem(item.id);
    _items.remove(item);
    notifyListeners();
  }

  Future<void> addCategory(PackingCategory category) async {
    await categoriesRepository.addCategory(category);
    await loadCategories();
    await setSelectedCategory(category);
  }

  Future<void> deleteCategory(PackingCategory category) async {
    if (_categories.length == 1) {
      throw Exception('Cannot delete the last category');
    }
    await categoriesRepository.deleteCategory(category.id);
    // If the deleted category is the selected one, select another one if available
    if (_selectedCategory?.id == category.id) {
      await loadCategories();
      if (_categories.isNotEmpty) {
        await setSelectedCategory(_categories.first);
      } else {
        _selectedCategory = null;
        _items = [];
        notifyListeners();
      }
    } else {
      await loadCategories();
    }
  }
}
