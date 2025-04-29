import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:packflow/core/repositories/hive_packing_list_repository.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/widgets/app_text_form_field.dart';

@RoutePage()
class EditPackingListView extends StatefulWidget {
  const EditPackingListView({required this.packingList, super.key});
  final PackingList packingList;

  @override
  State<EditPackingListView> createState() => _EditPackingListViewState();
}

class _EditPackingListViewState extends State<EditPackingListView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  DateTime? _returnDate;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.packingList.name);
    _descriptionController = TextEditingController(text: widget.packingList.description ?? '');
    _returnDate = widget.packingList.returnDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _savePackingList() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedPackingList = widget.packingList.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        returnDate: _returnDate,
        updatedAt: DateTime.now(),
      );

      await HivePackingListRepository().updatePackingList(updatedPackingList);

      if (mounted) {
        context.router.popForced(updatedPackingList);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update packing list: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _returnDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null && picked != _returnDate) {
      setState(() {
        _returnDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.packing_list_edit.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _savePackingList,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  AppTextFormField(
                    controller: _nameController,
                    labelText: LocaleKeys.packing_list_name.tr(),
                    hintText: LocaleKeys.packing_list_name.tr(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return LocaleKeys.error_field_required.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: _descriptionController,
                    labelText: LocaleKeys.packing_list_description.tr(),
                    hintText: LocaleKeys.packing_list_description.tr(),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(LocaleKeys.packing_list_travel_dates.tr()),
                    subtitle: Text(
                      _returnDate != null
                          ? DateFormat.yMMMd().format(_returnDate!)
                          : LocaleKeys.packing_list_dates_not_set.tr(),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_returnDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _returnDate = null;
                              });
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Display created date (read-only)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.packing_list_created_at.tr(),
                        style: TextStyle(color: Theme.of(context).colorScheme.outline),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: double.infinity,
                        child: Text(
                          DateFormat.yMMMd().format(widget.packingList.createdAt),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Items summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.packing_list_items_summary.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.packingList.checkedItemsCount} / ${widget.packingList.totalItems} ${LocaleKeys.packing_list_items_packed.tr()}',
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: widget.packingList.progress,
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
