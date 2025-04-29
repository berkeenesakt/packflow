import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:packflow/core/providers/home_provider.dart';
import 'package:packflow/core/repositories/hive_packing_list_repository.dart';
import 'package:packflow/core/router/app_router.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/widgets/empty_state_widget.dart';
import 'package:packflow/ui/widgets/home/info_card.dart';
import 'package:packflow/ui/widgets/home/packing_list_card.dart';
import 'package:packflow/ui/widgets/home/section_header.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _homeProvider = HomeProvider(
      packingListRepository: HivePackingListRepository(),
    );

    // Listen for changes in packing lists
    Hive.box<PackingList>('packing_lists').listenable().addListener(() {
      _homeProvider.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _homeProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.navigation_titles_home.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 400));
            _homeProvider.refresh();
          },
          child: Consumer<HomeProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Continue Packing section
                  if (provider.inProgressLists.isNotEmpty) ...[
                    SectionHeader(
                      title: LocaleKeys.home_continue_packing,
                      icon: Icons.edit_outlined,
                      iconColor: Colors.orange,
                      onViewAll: () {
                        // Navigate to packs tab
                        context.router.navigate(const NavigationRoute());
                      },
                    ),
                    ...provider.inProgressLists.map(
                      (list) {
                        return Column(
                          children: [
                            PackingListCard(
                              packingList: list,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Recent Lists section
                  if (provider.recentLists.isNotEmpty) ...[
                    SectionHeader(
                      title: LocaleKeys.home_recent_packing_lists,
                      icon: Icons.history_outlined,
                      onViewAll: () {
                        // Navigate to packs tab
                        context.router.navigate(const NavigationRoute());
                      },
                    ),
                    ...provider.recentLists.map(
                      (list) {
                        return Column(
                          children: [
                            PackingListCard(packingList: list),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ] else ...[
                    _buildEmptyState(context),
                  ],

                  // Fully Packed section
                  if (provider.fullyPackedLists.isNotEmpty) ...[
                    const SectionHeader(
                      title: LocaleKeys.home_fully_packed,
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green,
                    ),
                    ...provider.fullyPackedLists.map(
                      (list) {
                        return Column(
                          children: [
                            PackingListCard(
                              packingList: list,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Travel Tip section
                  Visibility(
                    visible: false,
                    child: Column(
                      children: [
                        const SectionHeader(
                          title: LocaleKeys.home_travel_tip,
                          icon: Icons.lightbulb_outline,
                          iconColor: Colors.amber,
                        ),
                        InfoCard(
                          title: LocaleKeys.home_travel_tip,
                          content: provider.travelTip,
                          icon: Icons.lightbulb_outline,
                          cardColor: const Color(0xFFFFF8E1),
                          iconColor: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 56 + MediaQuery.of(context).padding.bottom),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(child: EmptyStateWidget());
  }
}
