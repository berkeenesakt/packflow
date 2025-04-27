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
    this.hideInitiallySelectedItems = false,
    this.selectedCategory,
    this.scrollController,
    this.initiallySelectedItems = const [],
    super.key,
  });
  final List<PackingCategory> categories;

  final List<PackingItem> items;

  final void Function(String) onAddItem;

  final void Function(PackingCategory) onSelectCategory;

  final void Function(PackingItem)? onToggleItem;

  final void Function(PackingItem) onDeleteItem;

  final List<PackingItem> selectedItems;

  final bool hideInitiallySelectedItems;

  final List<PackingItem> initiallySelectedItems;

  final PackingCategory? selectedCategory;

  final ScrollController? scrollController;

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _itemFormKey = GlobalKey<FormState>();
  late PackingCategory selectedCategory;
  final _itemNameFocusNode = FocusNode();
  final _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory ?? widget.categories.first;
    if (widget.hideInitiallySelectedItems) {
      widget.items.removeWhere((item) => widget.initiallySelectedItems.contains(item));
    }

    // Auto focus the text field after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _itemNameFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _itemNameFocusNode.dispose();
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.onToggleItem != null ? 16 : 0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: widget.hideInitiallySelectedItems ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (widget.hideInitiallySelectedItems == true) ...[
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
                      padding: EdgeInsets.zero,
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
