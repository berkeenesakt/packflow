import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packflow/core/exceptions/item_exceptions.dart';
import 'package:packflow/core/providers/items_provider.dart';
import 'package:packflow/core/repositories/hive_categories_repository.dart';
import 'package:packflow/core/repositories/hive_items_repository.dart';
import 'package:packflow/core/repositories/hive_packing_list_repository.dart';
import 'package:packflow/core/router/app_router.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/widgets/add_item.dart';
import 'package:packflow/ui/widgets/app_text_form_field.dart';
import 'package:packflow/ui/widgets/items/item_card.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
// ignore: must_be_immutable
class PackView extends StatefulWidget {
  PackView({
    required this.packingList,
    super.key,
  });

  PackingList packingList;

  @override
  State<PackView> createState() => _PackViewState();
}

class _PackViewState extends State<PackView> with SingleTickerProviderStateMixin {
  final packRepository = HivePackingListRepository();
  final itemsRepository = HiveItemsRepository();
  final categoriesRepository = HiveCategoriesRepository();

  List<PackingItem> items = [];
  List<PackingCategory> categories = [];
  List<PackingCategory> dialogCategories = [];
  List<PackingItem> checkedItems = [];
  PackingCategory? selectedDialogCategory;
  PackingCategory? selectedCategory;
  List<PackingItem> itemsOnCategory = [];
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    items = widget.packingList.items;
    checkedItems = widget.packingList.checkedItems;

    // Initialize the animation controller
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Initialize with starting value
    _progressAnimation = Tween<double>(
      begin: 0,
      end: items.isEmpty ? 0 : checkedItems.length / items.length,
    ).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _progressAnimationController.forward();

    categoriesRepository.getCategories().then((val) async {
      setState(() {
        categories =
            val.where((category) => widget.packingList.items.any((item) => item.categoryId == category.id)).toList();
        selectedDialogCategory = categories.isNotEmpty ? categories.first : val.first;
        dialogCategories = val;
        itemsRepository
            .getItems()
            .then((value) => value.where((item) => item.categoryId == val.first.id).toList())
            .then((value) => setState(() => itemsOnCategory = value));
      });
    });
    Hive.box<PackingList>('packing_lists').listenable().addListener(() async {
      if (mounted) {
        final packingList = await packRepository.getPackingList(widget.packingList.id);
        setState(() {
          items = packingList?.items ?? [];
          checkedItems = packingList?.checkedItems ?? [];
          _updateProgressAnimation();
          log(items.toString());
          categoriesRepository
              .getCategories()
              .then((val) => val.where((category) => items.any((item) => item.categoryId == category.id)).toList())
              .then((val) => categories = val)
              .then((val) => log(categories.toString()))
              .then((val) {
            if (!categories.contains(selectedCategory)) {
              selectedCategory = null;
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  Future<void> _addItem(String name, String categoryId) async {
    late final PackingItem item;
    try {
      item = await itemsRepository.addItem(name, categoryId);
    } on ItemExistsException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.packing_list_item_exists.tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    if (mounted) {
      await packRepository.addItem(widget.packingList.id, item);
      setState(() {
        if (selectedDialogCategory?.id == categoryId) {
          itemsOnCategory = [item, ...itemsOnCategory];
        }
      });
    }
  }

  Future<void> _toggleDialogItem(PackingItem item) async {
    if (!mounted) return;

    if (items.contains(item)) {
      await packRepository.deleteItem(widget.packingList.id, item.id);
    } else {
      await packRepository.addItem(widget.packingList.id, item);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _updateProgressAnimation() {
    // Create a new animation with updated values
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: items.isEmpty ? 0 : checkedItems.length / items.length,
    ).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Reset and play the animation
    _progressAnimationController
      ..reset()
      ..forward();
  }

  Future<void> _deletePackingList() async {
    await packRepository.deletePackingList(widget.packingList.id);
    if (mounted) {
      context.router.popForced();
      context.router.popForced();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.packing_list_items.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final list = await packRepository.getPackingList(widget.packingList.id);
              await context.router
                  .push(
                EditPackingListRoute(
                  packingList: list!,
                ),
              )
                  .then((value) {
                if (value != null && value is PackingList) {
                  setState(() {
                    widget.packingList = value;
                  });
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(LocaleKeys.packing_list_delete.tr()),
                    content: Text(LocaleKeys.packing_list_delete_desc.tr()),
                    actions: [
                      TextButton(
                        onPressed: () => context.router.popForced(),
                        child: Text(LocaleKeys.general_cancel.tr()),
                      ),
                      TextButton(
                        onPressed: _deletePackingList,
                        child: Text(LocaleKeys.general_delete.tr()),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final isKeyboardVisible = keyboardHeight > 0;
              final initiallySelectedItems = List<PackingItem>.from(items);
              // ignore: no_leading_underscores_for_local_identifiers
              final _categoryNameController = TextEditingController();
              // ignore: no_leading_underscores_for_local_identifiers
              final _categoryFormKey = GlobalKey<FormState>();
              // ignore: no_leading_underscores_for_local_identifiers, unused_element
              void _showAddCategoryDialog(
                BuildContext context,
                ItemsProvider provider,
                void Function(void Function()) setState,
              ) {
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
                              setState(() {});
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

              return Padding(
                padding: EdgeInsets.only(bottom: isKeyboardVisible ? keyboardHeight : 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: isKeyboardVisible ? 0.9 : 0.7,
                    minChildSize: 0.5,
                    maxChildSize: 0.95,
                    builder: (context, scrollController) {
                      return ChangeNotifierProvider(
                        create: (context) => ItemsProvider(
                          itemsRepository: HiveItemsRepository(),
                          categoriesRepository: HiveCategoriesRepository(),
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Consumer<ItemsProvider>(
                              builder: (context, itemsProvider, child) {
                                return AddItem(
                                  categories: dialogCategories,
                                  items: itemsOnCategory,
                                  scrollController: scrollController,
                                  onAddItem: (item) {
                                    _addItem(item, selectedDialogCategory!.id);
                                  },
                                  //onAddCategory: () => _showAddCategoryDialog(context, itemsProvider, setState),
                                  //onDeleteCategory: itemsProvider.deleteCategory,
                                  showIndicator: true,
                                  onSelectCategory: (category) {
                                    setState(() => selectedDialogCategory = category);

                                    itemsRepository.getItems().then((value) {
                                      return value
                                          .where((item) => item.categoryId == selectedDialogCategory!.id)
                                          .toList();
                                    }).then((value) {
                                      final newItems = value..removeWhere(initiallySelectedItems.contains);
                                      setState(() => itemsOnCategory = newItems);
                                    });
                                  },
                                  selectedCategory: selectedDialogCategory,
                                  onToggleItem: (p0) async {
                                    await _toggleDialogItem(p0);
                                    setState(() {});
                                  },
                                  onDeleteItem: (item) {
                                    packRepository.deleteItem(widget.packingList.id, item.id);
                                    setState(() {
                                      itemsOnCategory.remove(item);
                                      checkedItems.remove(item);
                                    });
                                  },
                                  selectedItems: items,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<PackingItem>>(
        future: selectedCategory == null
            ? packRepository.getPackingList(widget.packingList.id).then((value) => value?.items ?? [])
            : packRepository
                .getPackingList(widget.packingList.id)
                .then((value) => value?.items.where((item) => item.categoryId == selectedCategory?.id).toList() ?? []),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.packingList.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${checkedItems.length}/${items.length}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (widget.packingList.description != null && widget.packingList.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.packingList.description!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMMMd().format(widget.packingList.createdAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(width: 16),
                        if (categories.isNotEmpty) ...[
                          Icon(
                            Icons.category_outlined,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${categories.length} ${LocaleKeys.categories_all.tr()}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ],
                    ),
                    if (items.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${((checkedItems.length / items.length) * 100).toInt()}% ${LocaleKeys.packing_list_items.tr()}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AnimatedBuilder(
                              animation: _progressAnimationController,
                              builder: (context, child) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: LinearProgressIndicator(
                                    value: _progressAnimation.value,
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = null;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selectedCategory == null
                                        ? Theme.of(context).colorScheme.primaryContainer
                                        : Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: selectedCategory == null
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(LocaleKeys.categories_all.tr()),
                                ),
                              ),
                            ),
                            for (final category in categories)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: selectedCategory?.id == category.id
                                          ? Theme.of(context).colorScheme.primaryContainer
                                          : Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: selectedCategory?.id == category.id
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
                    if (snapshot.data!.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(LocaleKeys.packing_list_no_items.tr()),
                        ),
                      ),
                    if (snapshot.data!.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            return ItemCard(
                              item: snapshot.data![index],
                              checkedItems: checkedItems,
                              onToggle: () =>
                                  packRepository.toggleItem(widget.packingList.id, snapshot.data![index].id),
                              onDelete: () {
                                packRepository.deleteItem(widget.packingList.id, snapshot.data![index].id);
                                setState(() {
                                  items.remove(snapshot.data![index]);
                                  checkedItems.remove(snapshot.data![index]);
                                });
                              },
                            );
                          },
                          itemCount: snapshot.data!.length,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
