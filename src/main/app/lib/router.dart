import 'package:auto_route/auto_route.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/categories/views/screens/category_settings.dart';
import 'package:spend_spent_spent/home/views/screens/home.dart';
import 'package:spend_spent_spent/login/views/screens/login_screen.dart';
import 'package:spend_spent_spent/settings/views/screens/settings.dart';
import 'package:spend_spent_spent/home/views/screens/middle_column.dart';
import 'package:spend_spent_spent/expenses/views/screens/right_column.dart';

import 'stats/views/screens/left_column.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Tab,Route')
class AppRouter extends _$AppRouter implements AutoRouteGuard {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true, children: [
          AutoRoute(page: LeftColumnRoute.page),
          AutoRoute(page: MiddleColumnRoute.page, initial: true),
          AutoRoute(page: RightColumnRoute.page)
        ]),
        AutoRoute(page: CategorySettingsRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: LoginRoute.page)
      ];

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    bool needLogin = false;
    try {
      final url = await service.getUrl();
      if (url.trim().isEmpty) {
        needLogin = true;
      } else {
        needLogin = await service.needLogin();
      }
    } catch (e) {
      needLogin = true;
    }
    if (!needLogin || resolver.route.name == LoginRoute.name) {
      // we continue navigation
      resolver.next();
    } else {
      // else we navigate to the Login page so we get authenticated

      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirect(const LoginRoute(), replace: true);
    }
  }
}
