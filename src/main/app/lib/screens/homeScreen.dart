import 'package:app/views/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:app/globals.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>  with AfterLayoutMixin<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Login(),
        ));
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var needLogin = await service.needLogin();
    print("Helllo $needLogin");
  }

}

