import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:packpal/core/router/app_router.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:packpal/ui/widgets/home/packing_list_card.dart';

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
    Hive.box<PackingList>('packing_lists').listenable().addListener(() {
      setState(() {
        _packingListsFuture = widget.repository.getAllPackingLists();
      });
    });
  }

  void _loadPackingLists() {
    _packingListsFuture = widget.repository.getAllPackingLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.packing_list_my_packing_lists.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        elevation: 0,
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
                LocaleKeys.packing_list_error_loading.tr(),
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
                    Icons.luggage_rounded,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    LocaleKeys.packing_list_no_lists_yet.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    LocaleKeys.packing_list_create_first_list.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.router.push(
                        CreatePackingListRoute(repository: widget.repository),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: Text(LocaleKeys.add_sheet_create_packing_list.tr()),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
              return Column(
                children: [
                  PackingListCard(
                    packingList: packingList,
                    repository: widget.repository,
                  ),
                  if (index < packingLists.length - 1) const SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
