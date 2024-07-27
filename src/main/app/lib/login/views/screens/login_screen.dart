import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/login/views/components/login.dart';
import 'package:spend_spent_spent/router.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Login(
            onLoginSuccess: () =>
                AutoRouter.of(context).push(const HomeRoute())),
      ),
    );
  }
}
