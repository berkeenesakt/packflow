import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:packpal/ui/widgets/items/item_card.dart';

@RoutePage()
class PackView extends StatefulWidget {
  const PackView({
    required this.packingList,
    required this.repository,
    super.key,
  });

  final PackingList packingList;
  final PackingListRepository repository;

  @override
  State<PackView> createState() => _PackViewState();
}

class _PackViewState extends State<PackView> {
  late PackingList _packingList;

  @override
  void initState() {
    super.initState();
    _packingList = widget.packingList;
  }

  Future<void> _toggleItem(String categoryId, String itemId) async {
    try {
      // Persist changes
      await widget.repository.toggleItem(_packingList.id, itemId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update item'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteItem(String itemId) async {
    await widget.repository.deleteItem(_packingList.id, itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_packingList.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section with overall progress
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_packingList.description != null) ...[
                  Text(
                    _packingList.description!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _packingList.progress,
                          minHeight: 8,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${(_packingList.progress * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${_packingList.checkedItems}/${_packingList.totalItems} items packed',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          // Categories and items list
          Expanded(
            child: _packingList.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No categories yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a category to start packing',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _packingList.items.length,
                    itemBuilder: (context, index) {
                      final item = _packingList.items[index];
                      return _CategoryCard(
                        item: item,
                        onToggleItem: (itemId) => _toggleItem(item.id, itemId),
                        onDeleteItem: _deleteItem,
                        packingList: _packingList,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add category/item functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.item,
    required this.onToggleItem,
    required this.packingList,
    required this.onDeleteItem,
  });

  final PackingItem item;
  final void Function(String itemId) onToggleItem;
  final void Function(String itemId) onDeleteItem;
  final PackingList packingList;

  @override
  Widget build(BuildContext context) {
    final checkedItems = packingList.checkedItems.where((item) => item.categoryId == item.id).length;
    final progress = checkedItems / item.quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(
                Icons.category_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 4,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$checkedItems/${item.quantity}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          children: [
            if (item.quantity == 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No items in this category',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: item.quantity,
                itemBuilder: (context, index) {
                  return ItemCard(
                    item: item,
                    onToggle: () => onToggleItem(item.id),
                    checkedItems: packingList.checkedItems,
                    onDelete: () => onDeleteItem(item.id),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
