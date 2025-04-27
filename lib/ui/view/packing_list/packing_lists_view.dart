import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:packpal/ui/widgets/empty_state_widget.dart';
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
      if (mounted) {
        setState(() {
          _packingListsFuture = widget.repository.getAllPackingLists();
        });
      }
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
            return const Center(child: EmptyStateWidget());
          }

          final packingLists = snapshot.data ?? [];

          if (packingLists.isEmpty) {
            return const Center(child: EmptyStateWidget());
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
