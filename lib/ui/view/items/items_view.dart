import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packflow/core/providers/items_provider.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/widgets/add_item.dart';
import 'package:packflow/ui/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  final _categoryFormKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog(BuildContext context, ItemsProvider provider) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.add_sheet_add_category.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _categoryFormKey,
                child: AppTextFormField(
                  controller: _categoryNameController,
                  labelText: LocaleKeys.categories_add_new.tr(),
                  hintText: LocaleKeys.packing_list_name.tr(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return LocaleKeys.error_field_required.tr();
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleKeys.general_cancel.tr()),
            ),
            TextButton(
              onPressed: () async {
                if (_categoryFormKey.currentState!.validate()) {
                  // Create new category
                  final category = PackingCategory(
                    id: const Uuid().v4(),
                    name: _categoryNameController.text.trim(),
                  );

                  // Add category and close dialog
                  await provider.addCategory(category);
                  await provider.setSelectedCategory(category);
                  // Clear text and close dialog
                  _categoryNameController.clear();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(LocaleKeys.general_save.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.items_title.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Consumer<ItemsProvider>(
                    builder: (context, provider, value) {
                      return AddItem(
                        categories: provider.categories,
                        items: provider.items,
                        onAddItem: provider.addItem,
                        onSelectCategory: provider.setSelectedCategory,
                        onToggleItem: null,
                        onDeleteItem: provider.deleteItem,
                        selectedItems: const [], // Empty list since we don't track selection
                        selectedCategory: provider.selectedCategory,
                        onAddCategory: () => _showAddCategoryDialog(context, provider),
                        onDeleteCategory: (category) => provider.deleteCategory(category),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
