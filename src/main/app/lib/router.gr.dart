// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CategorySettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CategorySettingsScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeScreen(),
      );
    },
    LeftColumnRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LeftColumnTab(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    MiddleColumnRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MiddleColumnTab(),
      );
    },
    RightColumnRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RightColumnTab(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SettingsScreen(),
      );
    },
  };
}

/// generated route for
/// [CategorySettingsScreen]
class CategorySettingsRoute extends PageRouteInfo<void> {
  const CategorySettingsRoute({List<PageRouteInfo>? children})
      : super(
          CategorySettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategorySettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LeftColumnTab]
class LeftColumnRoute extends PageRouteInfo<void> {
  const LeftColumnRoute({List<PageRouteInfo>? children})
      : super(
          LeftColumnRoute.name,
          initialChildren: children,
        );

  static const String name = 'LeftColumnRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MiddleColumnTab]
class MiddleColumnRoute extends PageRouteInfo<void> {
  const MiddleColumnRoute({List<PageRouteInfo>? children})
      : super(
          MiddleColumnRoute.name,
          initialChildren: children,
        );

  static const String name = 'MiddleColumnRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RightColumnTab]
class RightColumnRoute extends PageRouteInfo<void> {
  const RightColumnRoute({List<PageRouteInfo>? children})
      : super(
          RightColumnRoute.name,
          initialChildren: children,
        );

  static const String name = 'RightColumnRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
