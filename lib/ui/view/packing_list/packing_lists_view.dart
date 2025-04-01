import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:packpal/core/router/app_router.dart';
import 'package:packpal/generated/locale_keys.g.dart';

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
                  _PackingListCard(
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

class _PackingListCard extends StatelessWidget {
  const _PackingListCard({
    required this.packingList,
    required this.repository,
  });

  final PackingList packingList;
  final PackingListRepository repository;

  @override
  Widget build(BuildContext context) {
    final creationDate = packingList.createdAt;
    final formattedCreationDate = DateFormat('dd MMM yyyy').format(creationDate);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.surface.withOpacity(0.8) : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.router.push(
              PackRoute(
                packingList: packingList,
                repository: repository,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                              fontSize: 17,
                              letterSpacing: -0.3,
                            ),
                      ),
                    ),
                    if (packingList.departureDate != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(packingList.departureDate!),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (packingList.description != null && packingList.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    packingList.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.65),
                          height: 1.3,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SizedBox(
                              height: 4,
                              child: LinearProgressIndicator(
                                value: packingList.progress,
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${packingList.checkedItems.length}/${packingList.totalItems} ${LocaleKeys.packing_list_items_packed.tr()}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
                                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${(packingList.progress * 100).round()}%',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${LocaleKeys.packing_list_created_on.tr()}: $formattedCreationDate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
}
