import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/widgets/app_text_form_field.dart';
import 'package:packflow/ui/widgets/items/item_card.dart';

class AddItem extends StatefulWidget {
  const AddItem({
    required this.categories,
    required this.items,
    required this.onAddItem,
    required this.onSelectCategory,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.selectedItems,
    this.showIndicator = false,
    this.fullScreenView = false,
    this.selectedCategory,
    this.scrollController,
    this.onAddCategory,
    this.onDeleteCategory,
    super.key,
  });
  final List<PackingCategory> categories;

  final List<PackingItem> items;

  final void Function(String) onAddItem;

  final void Function(PackingCategory) onSelectCategory;

  final void Function(PackingItem)? onToggleItem;

  final void Function(PackingItem) onDeleteItem;

  final List<PackingItem> selectedItems;

  final PackingCategory? selectedCategory;

  final ScrollController? scrollController;

  final void Function()? onAddCategory;

  final Future<void> Function(PackingCategory)? onDeleteCategory;

  final bool showIndicator;

  final bool fullScreenView;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _itemFormKey = GlobalKey<FormState>();
  final _itemNameFocusNode = FocusNode();
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _itemNameFocusNode.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  void _showDeleteCategoryDialog(BuildContext context, PackingCategory category) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.categories_delete_category_title.tr()),
          content: Text(
            LocaleKeys.categories_delete_category_desc.tr(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(LocaleKeys.general_cancel.tr()),
            ),
            TextButton(
              onPressed: () async {
                if (widget.onDeleteCategory != null) {
                  try {
                    await widget.onDeleteCategory!(category);
                    Navigator.pop(context);
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.categories_delete_category_error.tr()),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(LocaleKeys.general_delete.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.onToggleItem != null ? 16 : 0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: widget.showIndicator ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (widget.showIndicator == true) ...[
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.onToggleItem != null
                    ? LocaleKeys.packing_list_items.tr()
                    : LocaleKeys.categories_categories.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in widget.categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            widget.onSelectCategory(category);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: widget.selectedCategory == category
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: widget.selectedCategory == category
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(category.name.tr()),
                                if (widget.onDeleteCategory != null && widget.selectedCategory == category) ...[
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () {
                                      _showDeleteCategoryDialog(context, category);
                                    },
                                    child: Icon(
                                      Icons.delete_forever_rounded,
                                      size: 16,
                                      color: widget.selectedCategory?.id == category.id
                                          ? Theme.of(context).colorScheme.onPrimaryContainer
                                          : Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    // Add Category button
                    if (widget.onAddCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: widget.onAddCategory,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  LocaleKeys.categories_add_new.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Add Item Field
                  Form(
                    key: _itemFormKey,
                    child: AppTextFormField(
                      focusNode: _itemNameFocusNode,
                      controller: _textFieldController,
                      labelText: LocaleKeys.packing_list_add_item_title.tr(),
                      hintText: LocaleKeys.packing_list_item_name.tr(),
                      onSubmit: (value) async {
                        if (!_itemFormKey.currentState!.validate()) return;
                        widget.onAddItem(value);
                        _textFieldController.clear();
                        _itemNameFocusNode.requestFocus(); // Keep focus on the text field
                      },
                      validator: (value) {
                        final val = value?.trim();
                        if (val == null || val.isEmpty) {
                          return LocaleKeys.packing_list_item_name_required.tr();
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
                          LocaleKeys.packing_list_no_items.tr(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return ItemCard(
                          key: Key(item.id),
                          item: item,
                          onToggle: widget.onToggleItem != null ? () => widget.onToggleItem!(item) : null,
                          checkedItems: widget.selectedItems,
                          onDelete: () => widget.onDeleteItem(item),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
