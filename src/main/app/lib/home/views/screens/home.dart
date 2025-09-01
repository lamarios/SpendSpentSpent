import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/guess_category_dialog.dart';
import 'package:spend_spent_spent/home/views/components/menu.dart';
import 'package:spend_spent_spent/identity/views/components/logout_handler.dart';
import 'package:spend_spent_spent/router.dart';

import '../../../globals.dart';

final _log = Logger('HomeScreen');

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _intentSub;

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setupIntentSharing();
  }

  void _setupIntentSharing() {
    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (value) async {
        _log.fine("Received file to open: ${value.length}");
        if (value.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (context.mounted) {
              GuessCategoryDialog.show(context, file: value.first);
            }
          });
        }
      },
      onError: (err) {
        _log.severe("Failed to receive file to open", err);
      },
    );

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) async {
      _log.fine("Received file to open 2 ${value.length}");

      if (value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (context.mounted) {
            GuessCategoryDialog.show(context, file: value.first);
          }
        });
      }

      // Tell the library that we are done processing the intent.
      ReceiveSharingIntent.instance.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final menuWidth = 250;
    final menuMargin = (screenWidth - menuWidth) / 2;

    return LogoutHandler(
      child: AutoTabsRouter.pageView(
        curve: Curves.easeInOutQuad,
        homeIndex: 1,
        builder: (context, child, _) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            floatingActionButton: IconButton(
              onPressed: () =>
                  AutoRouter.of(context).push(const SettingsRoute()),
              icon: const Icon(Icons.settings),
            ),
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: TABLET),
                        child: child,
                      ),
                    ),
                  ),
                  Positioned(
                    left: menuMargin,
                    right: menuMargin,
                    bottom: 36,
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: MainMenu(
                          tabsRouter: tabsRouter,
                          selectedIndex: tabsRouter.activeIndex,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*
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
*/
            /*
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
*/
          );
        },
      ),
    );
  }
}
