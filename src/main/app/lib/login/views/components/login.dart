import 'dart:core';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/login/models/login_page.dart';
import 'package:spend_spent_spent/login/state/login.dart';
import 'package:spend_spent_spent/login/views/components/loginForm.dart';
import 'package:spend_spent_spent/login/views/components/resetPassword.dart';
import 'package:spend_spent_spent/login/views/components/signUp.dart';
import 'package:spend_spent_spent/router.dart';
import 'package:spend_spent_spent/utils/views/components/error_listener.dart';

class Login extends StatelessWidget {
  final Function onLoginSuccess;

  const Login({super.key, required this.onLoginSuccess});

  double getTopPadding(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return min(50, height / 3);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    MediaQueryData mq = MediaQuery.of(context);
    bool tablet = isTablet(mq);

    double width = mq.size.width;
    double height = mq.size.height;

    if (tablet) {
      width = 500;
      height = 600;
    }

    return BlocProvider(
      create: (context) => LoginCubit(const LoginState(),
          context.read<CategoriesCubit>(), context.read<LastExpenseCubit>()),
      child: ErrorHandler<LoginCubit, LoginState>(
        showAsSnack: true,
        child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        width: width,
                        duration: panelTransition,
                        curve: Curves.easeInOutQuart,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(tablet ? 20 : 0)),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottom),
                          child: AnimatedSwitcher(
                            duration: panelTransition,
                            child: state.page == LoginPage.signUp
                                ? SignUp(
                                    key: ValueKey(state.page),
                                    onBack: () => cubit.signUp(false),
                                    server: cubit.urlController.text.trim())
                                : state.page == LoginPage.resetPassword
                                    ? ResetPassword(
                                        onBack: () =>
                                            cubit.resetPassword(false),
                                        server: cubit.urlController.text.trim(),
                                        key: ValueKey(state.page))
                                    : LoginForm(
                                        error: state.loginError,
                                        key: const ValueKey(false),
                                        urlController: cubit.urlController,
                                        config: state.config,
                                        logIn: (username, password) async {
                                          final loggedIn = await cubit.logIn(
                                              username, password);
                                          if (loggedIn && context.mounted) {
                                            AutoRouter.of(context).replaceAll(
                                                [const HomeRoute()]);
                                          }
                                        },
                                        showSignUp: () => cubit.signUp(true),
                                        showResetPassword: () =>
                                            cubit.resetPassword(true)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                  top: state.config == null ||
                          (state.config?.announcement.trim().length ?? 0) == 0
                      ? -200
                      : 0,
                  left: 0,
                  right: 0,
                  curve: Curves.easeInOutQuart,
                  duration: panelTransition,
                  child: Container(
                    color: colors.tertiaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        state.config?.announcement ?? '',
                        style: TextStyle(color: colors.onTertiaryContainer),
                      ),
                    ),
                  )),
            ],
          );
        }),
      ),
    );
  }
}

InputDecoration getFieldDecoration(
    String label, String hint, ColorScheme colors) {
  return InputDecoration(
      border: OutlineInputBorder(
          borderSide: BorderSide(color: colors.surfaceContainer)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.surfaceContainer)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colors.surfaceContainer)),
      hintText: hint,
      hintStyle: TextStyle(color: colors.onSurface.withOpacity(0.3)),
      filled: true,
      fillColor: colors.secondaryContainer);
}
