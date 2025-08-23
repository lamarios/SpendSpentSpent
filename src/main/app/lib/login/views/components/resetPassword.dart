import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/login/views/components/login.dart';

class ResetPassword extends StatefulWidget {
  final Function onBack;
  final String server;

  const ResetPassword({super.key, required this.onBack, required this.server});

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  TextEditingController usernameController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    await service.resetPassword(widget.server, usernameController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Reset password request sent successfully, check your email for instructions",
        ),
      ),
    );

    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(70.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: getFieldDecoration(
                "Email",
                "user@example.org",
                colors,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => resetPassword(context),
                    child: const Text('Reset password'),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => widget.onBack(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
