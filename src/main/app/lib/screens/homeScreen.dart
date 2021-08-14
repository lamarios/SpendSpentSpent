import 'package:after_layout/after_layout.dart';
import 'package:app/controllers/homeController.dart';
import 'package:app/globals.dart';
import 'package:app/views/login.dart';
import 'package:app/views/main.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  final homeController = HomeController();
  bool needLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: AnimatedBuilder(
            animation: homeController,
            builder: (context, _) {
              return LayoutBuilder(builder: (context, constraints) {
                return Stack(children: [
                  AnimatedOpacity(
                    duration: panelTransition,
                    curve: Curves.easeInOutQuart,
                    opacity:
                        homeController.homeState == HomeState.login ? 0.3 : 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [MainView()]),
                  ),
                  Visibility(
                    visible: needLogin,
                    child: AnimatedPositioned(
                      duration: panelTransition,
                      curve: Curves.easeInOutQuart,
                      left: 0,
                      right: 0,
                      top: homeController.homeState == HomeState.login
                          ? 0
                          : constraints.maxHeight,
                      bottom: homeController.homeState == HomeState.login
                          ? 0
                          : -constraints.maxHeight,
                      child: Login(onLoginSuccess: loginSuccess),
                    ),
                  )
                ]);
              });
            },
          ),
        ));
  }

  void loginSuccess() {
    homeController.changeHomeState(HomeState.normal);
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var needLogin = await service.needLogin();
    if (!needLogin) {
      FBroadcast.instance().broadcast(BROADCAST_LOGGED_IN);
    }
    homeController
        .changeHomeState(needLogin ? HomeState.login : HomeState.normal);
    setState(() {
      this.needLogin = needLogin;
    });
  }
}
