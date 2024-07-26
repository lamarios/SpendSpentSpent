import 'package:after_layout/after_layout.dart';
import 'package:auto_route/annotations.dart';
import 'package:fbroadcast_nullsafety/fbroadcast_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/preferences.dart';
import 'package:spend_spent_spent/views/login.dart';
import 'package:spend_spent_spent/views/main.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  HomeScreen() : super();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AfterLayoutMixin<HomeScreen> {
  late Widget homeWidget = getMainView();

  Widget getMainView() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [MainView()]);
  }

  Widget getLogin() {
    return Login(onLoginSuccess: loginSuccess);
  }

  @override
  initState() {
    super.initState();

    service.needLogin().then((needLogin) {
      if (!needLogin) {
        Preferences.get(Preferences.SERVER_URL).then((serverUrl) => service.getServerConfig(serverUrl));
      }
      this.homeWidget = needLogin ? getLogin() : getMainView();
    });
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return PlatformScaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(duration: panelTransition, switchInCurve: Curves.easeInOutQuart, switchOutCurve: Curves.easeInOutQuart, child: homeWidget),
        ));
  }

  void loginSuccess() {
    setState(() {
      this.homeWidget = getMainView();
    });
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
/*
    FBroadcast.instance().register(BROADCAST_LOGGED_OUT, (value, callback) {
      setState(() {
        this.homeWidget = getLogin();
      });
    });
*/
  }
}
