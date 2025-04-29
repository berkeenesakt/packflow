import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:packflow/core/providers/items_provider.dart';
import 'package:packflow/core/repositories/hive_categories_repository.dart';
import 'package:packflow/core/repositories/hive_items_repository.dart';
import 'package:packflow/core/repositories/hive_packing_list_repository.dart';
import 'package:packflow/core/router/app_router.dart';
import 'package:packflow/generated/locale_keys.g.dart';
import 'package:packflow/ui/view/home_view.dart';
import 'package:packflow/ui/view/items/items_view.dart';
import 'package:packflow/ui/view/packing_list/packing_lists_view.dart';
import 'package:packflow/ui/view/settings/settings_view.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

@RoutePage()
class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int currentPage = 0;

  final List<Widget> pagesList = [
    const HomeView(),
    PackingListsView(repository: HivePackingListRepository()),
    ChangeNotifierProvider(
      create: (context) => ItemsProvider(
        itemsRepository: HiveItemsRepository(),
        categoriesRepository: HiveCategoriesRepository(),
      ),
      child: const ItemsView(),
    ),
    const SettingsView(),
  ];

  final TextStyle labelStyle = const TextStyle(fontSize: 11);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: GestureDetector(onTap: () => FocusScope.of(context).unfocus(), child: pagesList[currentPage]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.blueAccent,
            ],
          ),
        ),
        child: FloatingActionButton(
          elevation: 0,
          highlightElevation: 0,
          splashColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          onPressed: () {
            context.router.push(CreatePackingListRoute(repository: HivePackingListRepository()));
          },
          child: const Icon(
            color: Colors.white,
            Icons.add,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: StylishBottomBar(
          elevation: 10,
          fabLocation: StylishBarFabLocation.center,
          notchStyle: NotchStyle.circle,
          hasNotch: true,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          items: [
            BottomBarItem(
              selectedColor: Colors.blue,
              icon: const Icon(Icons.dashboard),
              title: Text(
                style: labelStyle,
                LocaleKeys.navigation_titles_home.tr(),
              ),
            ),
            BottomBarItem(
              selectedColor: Colors.blue,
              icon: const Icon(Icons.backpack),
              title: Text(
                style: labelStyle,
                LocaleKeys.navigation_titles_packs.tr(),
              ),
            ),
            BottomBarItem(
              selectedColor: Colors.blue,
              icon: const Icon(Icons.list),
              title: Text(
                style: labelStyle,
                LocaleKeys.navigation_titles_items.tr(),
              ),
            ),
            BottomBarItem(
              selectedColor: Colors.blue,
              icon: const Icon(Icons.settings),
              title: Text(
                style: labelStyle,
                LocaleKeys.navigation_titles_settings.tr(),
              ),
            ),
          ],
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.blink,
          ),
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
        ),
      ),
    );
  }
}
