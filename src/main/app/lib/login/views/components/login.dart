import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor/motor.dart';
import 'package:spend_spent_spent/categories/state/categories.dart';
import 'package:spend_spent_spent/expenses/state/last_expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/identity/states/username_password.dart';
import 'package:spend_spent_spent/identity/views/components/login_handler.dart';
import 'package:spend_spent_spent/login/models/login_page.dart';
import 'package:spend_spent_spent/login/state/login.dart';
import 'package:spend_spent_spent/login/views/components/loginForm.dart';
import 'package:spend_spent_spent/login/views/components/resetPassword.dart';
import 'package:spend_spent_spent/login/views/components/signUp.dart';
import 'package:spend_spent_spent/utils/views/components/error_dialog.dart';

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

    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    MediaQueryData mq = MediaQuery.of(context);
    bool tablet = isTablet(mq);

    double width = mq.size.width;

    if (tablet) {
      width = 500;
    }

    return BlocProvider(
      create: (context) => LoginCubit(
        const LoginState(),
        context.read<CategoriesCubit>(),
        context.read<LastExpenseCubit>(),
        context.read<UsernamePasswordCubit>(),
      ),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return LoginHandler(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleMotionBuilder(
                    motion: MaterialSpringMotion.expressiveSpatialDefault(),
                    value: (state.config?.announcement.trim().length ?? 0) > 0
                        ? 1
                        : 0,
                    builder: (context, value, child) => Transform.scale(
                      scaleY: value,
                      alignment: Alignment.topCenter,
                      child: Opacity(opacity: value.clamp(0, 1), child: child),
                    ),
                    child: Container(
                      color: colors.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          state.config?.announcement ?? '',
                          style: TextStyle(color: colors.onTertiaryContainer),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      width: width,
                      duration: panelTransition,
                      curve: Curves.easeInOutQuart,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          tablet ? bigItemBorderRadius : 0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: bottom),
                        child: AnimatedSwitcher(
                          duration: panelTransition,
                          child:
                              state.error == null &&
                                  state.page == LoginPage.signUp
                              ? SignUp(
                                  key: ValueKey(state.page),
                                  onBack: () => cubit.signUp(false),
                                  server: cubit.urlController.text.trim(),
                                )
                              : state.error == null &&
                                    state.page == LoginPage.resetPassword
                              ? ResetPassword(
                                  onBack: () => cubit.resetPassword(false),
                                  server: cubit.urlController.text.trim(),
                                  key: ValueKey(state.page),
                                )
                              : LoginForm(
                                  error: state.loginError,
                                  key: const ValueKey(false),
                                  urlController: cubit.urlController,
                                  config: state.config,
                                  logIn: (username, password) async {
                                    await cubit.logIn(username, password);
                                  },
                                  loginWithSso: () async {
                                    await cubit.logInWithOidc();
                                  },
                                  showSignUp: () => cubit.signUp(true),
                                  showResetPassword: () =>
                                      cubit.resetPassword(true),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SingleMotionBuilder(
                      motion: MaterialSpringMotion.expressiveSpatialDefault(),
                      value: state.error != null ? 1 : 0,
                      builder: (context, value, child) => Transform.scale(
                        scaleY: value,
                        child: Opacity(
                          opacity: value.clamp(0, 1),
                          child: child,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 75,
                          right: 75,
                          bottom: 100,
                        ),
                        width: width,
                        decoration: BoxDecoration(
                          color: colors.errorContainer,
                          borderRadius: BorderRadius.circular(
                            bigItemBorderRadius,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: Row(
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error_outline, color: colors.error),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: ErrorDialog.buildError(
                                    context,
                                    state.error,
                                    state.stackTrace,
                                  ),
                                ),
                              ),
                            ],
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

InputDecoration getFieldDecoration(
  String label,
  String hint,
  ColorScheme colors,
) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: colors.surfaceContainer),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.surfaceContainer),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: colors.surfaceContainer),
    ),
    hintText: hint,
    hintStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.3)),
    filled: true,
    fillColor: colors.secondaryContainer,
  );
}
