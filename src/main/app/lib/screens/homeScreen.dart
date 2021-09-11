import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/utils/preferences.dart';
import 'package:spend_spent_spent/views/login.dart';
import 'package:spend_spent_spent/views/main.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  late Widget homeWidget = getMainView();

  Widget getMainView() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center, children: [MainView()]);
  }

  Widget getLogin() {
    return Login(onLoginSuccess: loginSuccess);
  }

  @override
  initState() {
    super.initState();

    service.needLogin().then((needLogin) {
      this.homeWidget = needLogin ? getLogin() : getMainView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(duration: panelTransition,
              switchInCurve: Curves.easeInOutQuart,
              switchOutCurve: Curves.easeInOutQuart,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
              child: homeWidget),
        ));
  }

  void loginSuccess() {
    setState(() {
      this.homeWidget = getMainView();
    });
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    FBroadcast.instance().register(BROADCAST_LOGGED_OUT, (value, callback) {
      setState(() {
        this.homeWidget = getLogin();
      });
    });
  }
}
