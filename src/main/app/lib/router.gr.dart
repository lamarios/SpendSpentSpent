// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [CategoryListTab]
class CategoryListRoute extends PageRouteInfo<void> {
  const CategoryListRoute({List<PageRouteInfo>? children})
    : super(
        CategoryListRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'CategoryListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoryListTab();
    },
  );
}

/// generated route for
/// [CategorySettingsScreen]
class CategorySettingsRoute extends PageRouteInfo<void> {
  const CategorySettingsRoute({List<PageRouteInfo>? children})
    : super(
        CategorySettingsRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'CategorySettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategorySettingsScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children, argsEquality: false);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [ImageViewerScreen]
class ImageViewerRoute extends PageRouteInfo<ImageViewerRouteArgs> {
  ImageViewerRoute({
    Key? key,
    required List<SssFile> images,
    int initiallySelected = 0,
    List<PageRouteInfo>? children,
  }) : super(
         ImageViewerRoute.name,
         args: ImageViewerRouteArgs(
           key: key,
           images: images,
           initiallySelected: initiallySelected,
         ),
         initialChildren: children,
         argsEquality: false,
       );

  static const String name = 'ImageViewerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImageViewerRouteArgs>();
      return ImageViewerScreen(
        key: args.key,
        images: args.images,
        initiallySelected: args.initiallySelected,
      );
    },
  );
}

class ImageViewerRouteArgs {
  const ImageViewerRouteArgs({
    this.key,
    required this.images,
    this.initiallySelected = 0,
  });

  final Key? key;

  final List<SssFile> images;

  final int initiallySelected;

  @override
  String toString() {
    return 'ImageViewerRouteArgs{key: $key, images: $images, initiallySelected: $initiallySelected}';
  }
}

/// generated route for
/// [LeftColumnTab]
class LeftColumnRoute extends PageRouteInfo<void> {
  const LeftColumnRoute({List<PageRouteInfo>? children})
    : super(
        LeftColumnRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'LeftColumnRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LeftColumnTab();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children, argsEquality: false);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MiddleColumnTab]
class MiddleColumnRoute extends PageRouteInfo<void> {
  const MiddleColumnRoute({List<PageRouteInfo>? children})
    : super(
        MiddleColumnRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'MiddleColumnRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MiddleColumnTab();
    },
  );
}

/// generated route for
/// [MonthlyStatsTab]
class MonthlyStatsRoute extends PageRouteInfo<void> {
  const MonthlyStatsRoute({List<PageRouteInfo>? children})
    : super(
        MonthlyStatsRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'MonthlyStatsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MonthlyStatsTab();
    },
  );
}

/// generated route for
/// [RecurringExpenseListTab]
class RecurringExpenseListRoute extends PageRouteInfo<void> {
  const RecurringExpenseListRoute({List<PageRouteInfo>? children})
    : super(
        RecurringExpenseListRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'RecurringExpenseListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecurringExpenseListTab();
    },
  );
}

/// generated route for
/// [RightColumnTab]
class RightColumnRoute extends PageRouteInfo<void> {
  const RightColumnRoute({List<PageRouteInfo>? children})
    : super(
        RightColumnRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'RightColumnRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RightColumnTab();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children, argsEquality: false);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [YearlyStatsTab]
class YearlyStatsRoute extends PageRouteInfo<void> {
  const YearlyStatsRoute({List<PageRouteInfo>? children})
    : super(
        YearlyStatsRoute.name,
        initialChildren: children,
        argsEquality: false,
      );

  static const String name = 'YearlyStatsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const YearlyStatsTab();
    },
  );
}
