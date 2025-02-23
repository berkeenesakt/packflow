import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
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
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _departureDate;
  bool _isLoading = false;

  bool get _isEditing => widget.packingList != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.packingList!.name;
      _descriptionController.text = widget.packingList!.description ?? '';
      _departureDate = widget.packingList!.departureDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _departureDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() => _departureDate = date);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final packingList = PackingList(
        id: _isEditing ? widget.packingList!.id : const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        createdAt: _isEditing ? widget.packingList!.createdAt : DateTime.now(),
        departureDate: _departureDate,
        categories: _isEditing ? widget.packingList!.categories : [],
      );

      if (_isEditing) {
        await widget.repository.updatePackingList(packingList);
      } else {
        await widget.repository.createPackingList(packingList);
      }

      if (mounted) {
        context.back();
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${_isEditing ? 'updating' : 'creating'} packing list'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Packing List' : 'Create Packing List'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter a name for your packing list',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add a description for your packing list',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Departure Date (optional)'),
              subtitle: Text(
                _departureDate != null
                    ? '${_departureDate!.day}/${_departureDate!.month}/${_departureDate!.year}'
                    : 'Not set',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_departureDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _departureDate = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(_isEditing ? 'Save Changes' : 'Create List'),
            ),
          ],
        ),
      ),
    );
  }
}
