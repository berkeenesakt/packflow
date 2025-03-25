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
/// [NavigationView]
class NavigationRoute extends PageRouteInfo<void> {
  const NavigationRoute({List<PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NavigationView();
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
/// [PackView]
class PackRoute extends PageRouteInfo<PackRouteArgs> {
  PackRoute({
    Key? key,
    required PackingList packingList,
    required PackingListRepository repository,
    List<PageRouteInfo>? children,
  }) : super(
          PackRoute.name,
          args: PackRouteArgs(
            key: key,
            packingList: packingList,
            repository: repository,
          ),
          initialChildren: children,
        );

  static const String name = 'PackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PackRouteArgs>();
      return PackView(
        key: args.key,
        packingList: args.packingList,
        repository: args.repository,
      );
    },
  );
}

class PackRouteArgs {
  const PackRouteArgs({
    this.key,
    required this.packingList,
    required this.repository,
  });

  final Key? key;
  final PackingList packingList;
  final PackingListRepository repository;

  @override
  String toString() {
    return 'PackRouteArgs{key: $key, packingList: $packingList, repository: $repository}';
  }
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
