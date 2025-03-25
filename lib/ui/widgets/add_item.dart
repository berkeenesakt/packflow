import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:packpal/ui/widgets/app_text_form_field.dart';
import 'package:packpal/ui/widgets/items/item_card.dart';

class AddItem extends StatefulWidget {
  const AddItem({
    required this.categories,
    required this.items,
    required this.onAddItem,
    required this.onSelectCategory,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.selectedItems,
    super.key,
  });
  final List<PackingCategory> categories;

  final List<PackingItem> items;

  final void Function(String) onAddItem;

  final void Function(PackingCategory) onSelectCategory;

  final void Function(PackingItem) onToggleItem;

  final void Function(PackingItem) onDeleteItem;

  final List<PackingItem> selectedItems;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _itemFormKey = GlobalKey<FormState>();
  late PackingCategory selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(LocaleKeys.packing_list_items.tr(), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in widget.categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        widget.onSelectCategory(category);
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selectedCategory.id == category.id
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: selectedCategory.id == category.id
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Text(category.name.tr()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        // Add Item Field
        Form(
          key: _itemFormKey,
          child: AppTextFormField(
            labelText: 'Item Name',
            hintText: 'Item Name',
            onSubmit: (value) async {
              if (!_itemFormKey.currentState!.validate()) return;
              widget.onAddItem(value);
              _itemFormKey.currentState!.reset();
            },
            validator: (value) {
              final val = value?.trim();
              if (val == null || val.isEmpty) {
                return 'Item Name is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),

        // Items grid
        if (widget.items.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No items added yet. Create a new item below.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: widget.items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return ItemCard(
                item: item,
                onToggle: () => widget.onToggleItem(item),
                checkedItems: widget.selectedItems,
                onDelete: () => widget.onDeleteItem(item),
              );
            },
          ),
      ],
    );
  }
}
