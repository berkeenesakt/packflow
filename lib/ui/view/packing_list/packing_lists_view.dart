import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';

@RoutePage()
class PackingListsView extends StatefulWidget {
  const PackingListsView({
    required this.repository,
    super.key,
  });

  final PackingListRepository repository;

  @override
  State<PackingListsView> createState() => _PackingListsViewState();
}

class _PackingListsViewState extends State<PackingListsView> {
  late Future<List<PackingList>> _packingListsFuture;

  @override
  void initState() {
    super.initState();
    _loadPackingLists();
  }

  void _loadPackingLists() {
    _packingListsFuture = widget.repository.getAllPackingLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Packing Lists'),
      ),
      body: FutureBuilder<List<PackingList>>(
        future: _packingListsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading packing lists',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            );
          }

          final packingLists = snapshot.data ?? [];

          if (packingLists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No packing lists yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first packing list',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: packingLists.length,
            itemBuilder: (context, index) {
              final packingList = packingLists[index];
              return _PackingListCard(packingList: packingList);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO(berke): implement navigation to create packing list screen.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PackingListCard extends StatelessWidget {
  const _PackingListCard({
    required this.packingList,
  });

  final PackingList packingList;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO(berke): implement navigation to packing list details.
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      packingList.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (packingList.departureDate != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(packingList.departureDate!),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ],
              ),
              if (packingList.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  packingList.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: packingList.progress,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${(packingList.progress * 100).round()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${packingList.checkedItems}/${packingList.totalItems} items packed',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
