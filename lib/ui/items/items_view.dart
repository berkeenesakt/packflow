import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packpal/core/providers/items_provider.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:packpal/ui/widgets/add_item.dart';
import 'package:provider/provider.dart';

class ItemsView extends StatelessWidget {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.items_title.tr()),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: AddItem(
                    categories: provider.categories,
                    items: provider.items,
                    onAddItem: provider.addItem,
                    onSelectCategory: provider.setSelectedCategory,
                    onToggleItem: null,
                    onDeleteItem: provider.deleteItem,
                    selectedItems: const [], // Empty list since we don't track selection
                    selectedCategory: provider.selectedCategory,
                  ),
                ),
              ],
            ),
    );
  }
}
