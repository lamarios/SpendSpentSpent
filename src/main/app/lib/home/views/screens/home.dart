import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/identity/views/components/logout_handler.dart';
import 'package:spend_spent_spent/router.dart';

import '../../../globals.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LogoutHandler(
      child: AutoTabsRouter.pageView(
          curve: Curves.easeInOutQuad,
          homeIndex: 1,
          builder: (context, child, _) {
            final tabsRouter = AutoTabsRouter.of(context);
            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: TABLET),
                        child: child)),
              ),
              appBar: AppBar(
                title: Row(
                  children: [
                    getIcon('groceries_bag', size: 25, color: colors.onSurface),
                    const Gap(10),
                    const Text('SpendSpentSpent'),
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () =>
                          AutoRouter.of(context).push(const SettingsRoute()),
                      icon: const Icon(Icons.settings))
                ],
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: (value) =>
                    tabsRouter.setActiveIndex(value),
                destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.auto_graph), label: 'graphs'),
                  NavigationDestination(
                      icon: Icon(Icons.square_rounded), label: 'expenses'),
                  NavigationDestination(
                      icon: Icon(Icons.list), label: 'detail'),
                ],
              ),
            );
          }),
    );
  }
}
