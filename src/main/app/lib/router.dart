import 'package:auto_route/auto_route.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter{
  @override
  List<AutoRoute> get routes => [
    /// routes go here
  ];
}