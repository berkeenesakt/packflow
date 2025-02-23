// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CreatePackingListView]
class CreatePackingListRoute extends PageRouteInfo<CreatePackingListRouteArgs> {
  CreatePackingListRoute({
    required PackingListRepository repository,
    PackingList? packingList,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CreatePackingListRoute.name,
          args: CreatePackingListRouteArgs(
            repository: repository,
            packingList: packingList,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CreatePackingListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreatePackingListRouteArgs>();
      return CreatePackingListView(
        repository: args.repository,
        packingList: args.packingList,
        key: args.key,
      );
    },
  );
}

class CreatePackingListRouteArgs {
  const CreatePackingListRouteArgs({
    required this.repository,
    this.packingList,
    this.key,
  });

  final PackingListRepository repository;

  final PackingList? packingList;

  final Key? key;

  @override
  String toString() {
    return 'CreatePackingListRouteArgs{repository: $repository, packingList: $packingList, key: $key}';
  }
}

/// generated route for
/// [HomeView]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeView();
    },
  );
}

/// generated route for
/// [OnboardingView]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingView();
    },
  );
}

/// generated route for
/// [PackingListsView]
class PackingListsRoute extends PageRouteInfo<PackingListsRouteArgs> {
  PackingListsRoute({
    required PackingListRepository repository,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PackingListsRoute.name,
          args: PackingListsRouteArgs(
            repository: repository,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PackingListsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PackingListsRouteArgs>();
      return PackingListsView(
        repository: args.repository,
        key: args.key,
      );
    },
  );
}

class PackingListsRouteArgs {
  const PackingListsRouteArgs({
    required this.repository,
    this.key,
  });

  final PackingListRepository repository;

  final Key? key;

  @override
  String toString() {
    return 'PackingListsRouteArgs{repository: $repository, key: $key}';
  }
}

/// generated route for
/// [SplashView]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashView();
    },
  );
}
