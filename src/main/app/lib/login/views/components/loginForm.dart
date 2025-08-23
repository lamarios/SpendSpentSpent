import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/login/views/components/login.dart';
import 'package:spend_spent_spent/settings/models/config.dart';

class LoginForm extends StatefulWidget {
  final Function showSignUp, showResetPassword;
  final Function(String username, String password) logIn;
  final Function() loginWithSso;

  final Config? config;
  final TextEditingController urlController;
  final String error;

  const LoginForm({
    super.key,
    required this.showResetPassword,
    required this.error,
    this.config,
    required this.showSignUp,
    required this.logIn,
    required this.loginWithSso,
    required this.urlController,
  });

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> with AfterLayoutMixin<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  double getIconSize(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return min(150, height / 3);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AutofillGroup(
      child: Container(
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                decoration: const BoxDecoration(borderRadius: defaultBorder),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: getIcon(
                          'groceries_bag',
                          size: getIconSize(context),
                          color: colors.primary,
                        ),
                      ),
                      Visibility(
                        visible: (kIsWeb && !kReleaseMode) || !kIsWeb,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Server URL',
                              style: TextStyle(
                                color: colors.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: (kIsWeb && !kReleaseMode) || !kIsWeb,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            showCursor: true,
                            controller: widget.urlController,
                            keyboardType: TextInputType.url,
                            autocorrect: false,
                            decoration: getFieldDecoration(
                              "",
                              "https://sss-server.example.com",
                              colors,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.username],
                          autocorrect: false,
                          decoration: getFieldDecoration(
                            "Email",
                            "user@example.org",
                            colors,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: passwordController,
                          autofillHints: const [AutofillHints.password],
                          obscureText: true,
                          decoration: getFieldDecoration(
                            "Password",
                            "",
                            colors,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.error.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: defaultBorder,
                              color: Colors.red.shade400,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(widget.error),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: FilledButton.tonal(
                                onPressed: () => widget.logIn(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                ),
                                child: const Text('Log in'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.config?.oidc != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text("or"),
                              const Gap(8),
                              FilledButton.tonal(
                                onPressed: () => widget.loginWithSso(),
                                child: Text(
                                  'Log in with ${widget.config?.oidc?.name}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      Visibility(
                        visible: widget.config?.allowSignup ?? false,
                        child: TextButton(
                          onPressed: () => widget.showSignUp(),
                          child: Text(
                            'or Sign Up',
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.config?.canResetPassword ?? false,
                        child: TextButton(
                          onPressed: () => widget.showResetPassword(),
                          child: Text(
                            'Forgot password ?',
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}
