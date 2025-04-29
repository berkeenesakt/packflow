import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packflow/core/providers/items_provider.dart';
import 'package:packflow/core/repositories/categories_repository.dart';
import 'package:packflow/core/repositories/hive_categories_repository.dart';
import 'package:packflow/core/repositories/hive_items_repository.dart';
import 'package:packflow/core/repositories/items_repository.dart';
import 'package:packflow/core/repositories/packing_list_repository.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/view/packing_list/create_packing_list_provider.dart';
import 'package:packflow/ui/widgets/add_item.dart';
import 'package:packflow/ui/widgets/app_filled_button.dart';
import 'package:packflow/ui/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CreatePackingListView extends StatefulWidget {
  const CreatePackingListView({
    required this.repository,
    this.packingList,
    super.key,
  });

  final PackingListRepository repository;
  final PackingList? packingList;

  @override
  State<CreatePackingListView> createState() => _CreatePackingListViewState();
}

class _CreatePackingListViewState extends State<CreatePackingListView> {
  final _formKey = GlobalKey<FormState>();
  late CreatePackingListProvider _provider;
  final ItemsRepository _itemsRepository = HiveItemsRepository();
  final CategoriesRepository _categoriesRepository = HiveCategoriesRepository();

  final _categoryFormKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _provider = CreatePackingListProvider(
      repository: widget.repository,
      itemsRepository: _itemsRepository,
      categoriesRepository: _categoriesRepository,
      packingList: widget.packingList,
    );
    Hive.box<PackingItem>('packing_items').listenable().addListener(() {
      _provider.loadItems();
    });
    Hive.box<PackingCategory>('categories').listenable().addListener(() {
      _provider.loadCategories();
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (date == null) return;
    _provider.setReturnDate(date);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _provider.save();

    if (success && mounted) {
      context.back();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            LocaleKeys.packing_list_error_saving.tr(
              namedArgs: {
                'action': _provider.isEditing ? LocaleKeys.common_updating.tr() : LocaleKeys.common_creating.tr(),
              },
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddCategoryDialog(BuildContext context, CreatePackingListProvider provider) {
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
    return ChangeNotifierProvider<CreatePackingListProvider>.value(
      value: _provider,
      child: Builder(
        builder: (context) {
          final provider = Provider.of<CreatePackingListProvider>(context);
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                provider.isEditing
                    ? LocaleKeys.packing_list_edit_title.tr()
                    : LocaleKeys.packing_list_create_title.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        AppTextFormField(
                          controller: provider.nameController,
                          labelText: LocaleKeys.packing_list_name_label.tr(),
                          hintText: LocaleKeys.packing_list_name_hint.tr(),
                          validator: (value) {
                            final val = value?.trim();
                            if (val == null || val.isEmpty || val.length < 3) {
                              return LocaleKeys.packing_list_name_validation.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextFormField(
                          controller: provider.descriptionController,
                          labelText: LocaleKeys.packing_list_description_label.tr(),
                          hintText: LocaleKeys.packing_list_description_hint.tr(),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(LocaleKeys.packing_list_travel_dates.tr()),
                          subtitle: Text(
                            provider.returnDate != null
                                ? DateFormat.yMMMd().format(provider.returnDate!)
                                : LocaleKeys.packing_list_dates_not_set.tr(),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (provider.returnDate != null)
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: provider.clearDateRange,
                                ),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: _selectDateRange,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Items Section
                  AddItem(
                    categories: provider.categories,
                    items: provider.items,
                    onAddItem: (String itemName) => provider.addItem(itemName, context),
                    onSelectCategory: provider.setSelectedCategory,
                    onAddCategory: () => _showAddCategoryDialog(context, provider),
                    onToggleItem: provider.toggleItem,
                    onDeleteItem: provider.deleteItem,
                    selectedItems: provider.selectedItems,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AppFilledButton(
                      onPressed: _save,
                      text: provider.isEditing
                          ? LocaleKeys.packing_list_save_changes.tr()
                          : LocaleKeys.packing_list_create_button.tr(),
                      isLoading: provider.isLoading,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
