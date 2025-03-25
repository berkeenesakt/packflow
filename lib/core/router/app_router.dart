import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gen/gen.dart';
import 'package:packpal/core/repositories/packing_list_repository.dart';
import 'package:packpal/ui/view/home_view.dart';
import 'package:packpal/ui/view/navigation/navigation_view.dart';
import 'package:packpal/ui/view/onboarding/onboarding_view.dart';
import 'package:packpal/ui/view/pack/pack_view.dart';
import 'package:packpal/ui/view/packing_list/create_packing_list_view.dart';
import 'package:packpal/ui/view/packing_list/packing_lists_view.dart';
import 'package:packpal/ui/view/splash/splash_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/', initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),
        AutoRoute(page: NavigationRoute.page, path: '/navigation'),
        AutoRoute(page: CreatePackingListRoute.page, path: '/create-packing-list'),
        AutoRoute(page: PackRoute.page, path: '/pack'),
      ];
}
