import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packpal/core/repositories/categories_repository.dart';
import 'package:packpal/core/repositories/hive_categories_repository.dart';
import 'package:packpal/core/repositories/hive_items_repository.dart';
import 'package:packpal/core/repositories/items_repository.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:packpal/ui/view/packing_list/create_packing_list_provider.dart';
import 'package:packpal/ui/widgets/add_item.dart';
import 'package:packpal/ui/widgets/app_filled_button.dart';
import 'package:packpal/ui/widgets/app_text_form_field.dart';
import 'package:packpal/ui/widgets/date_range_picker/date_range_picker.dart' as custom_picker;
import 'package:provider/provider.dart';

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
    final dateRange = await custom_picker.DateRangePickerDialog.show(
      context,
      initialStartDate: _provider.startDate,
      initialEndDate: _provider.endDate,
    );
    if (dateRange != null && mounted) {
      _provider.setDateRange(dateRange.start, dateRange.end);
    }
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
        ),
      );
    }
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
                            provider.startDate != null && provider.endDate != null
                                ? '${DateFormat('dd/MM/yyyy').format(provider.startDate!)} - ${DateFormat('dd/MM/yyyy').format(provider.endDate!)}'
                                : LocaleKeys.packing_list_dates_not_set.tr(),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (provider.startDate != null)
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
                    onAddItem: provider.addItem,
                    onSelectCategory: provider.setSelectedCategory,
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
