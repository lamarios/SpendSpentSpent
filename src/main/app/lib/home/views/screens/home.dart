import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:spend_spent_spent/add_expense_dialog/views/components/guess_category_dialog.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late StreamSubscription _intentSub;
  bool _sharedFileIsHandled = false;

  @override
  void dispose() {
    _intentSub.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      _setupIntentSharing();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<CategoriesCubit>().getCategories();
    }
  }

  void _setupIntentSharing() {
    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
      (value) async {
        _log.fine("Received file to open while app is opened: ${value.length}");
        if (value.isNotEmpty && !_sharedFileIsHandled) {
          _sharedFileIsHandled = true;
          if (context.mounted) {
            GuessCategoryDialog.show(
              context,
              file: value.first,
            ).then((value) => _sharedFileIsHandled = false);
          }
        }
      },
      onError: (err) {
        _log.severe("Failed to receive file to open", err);
      },
    );

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) async {
      _log.fine("Received file to open from app start: ${value.length}");

      if (value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (context.mounted) {
            _sharedFileIsHandled = true;
            GuessCategoryDialog.show(
              context,
              file: value.first,
            ).then((value) => _sharedFileIsHandled = false);
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

    final safeAreaPadding = MediaQuery.paddingOf(context).bottom;

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
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: 45 + safeAreaPadding,
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Positioned(
                    left: menuMargin,
                    right: menuMargin,
                    bottom: 20,
                    child: SafeArea(
                      top: false,
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
