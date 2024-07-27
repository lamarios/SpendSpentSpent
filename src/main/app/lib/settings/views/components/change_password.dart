import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  bool invalid = false, canSave = false;

  @override
  initState() {
    super.initState();
    passwordController.addListener(valueChanged);
    passwordRepeatController.addListener(valueChanged);
  }

  savePassword() async {
    User user = await service.getCurrentUser();
    user = user.copyWith(password: passwordController.text);

    await service.saveUser(user);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Password saved")));
  }

  valueChanged() {
    setState(() {
      invalid = (passwordRepeatController.text.trim().isNotEmpty &&
          passwordRepeatController.text.trim() !=
              passwordController.text.trim());
      canSave = passwordRepeatController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New password'),
            TextField(
              obscureText: true,
              controller: passwordController,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Repeat new password'),
            ),
            TextField(
              obscureText: true,
              controller: passwordRepeatController,
            ),
            Visibility(
                visible: invalid,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Passwords don\'t match'),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: invalid || !canSave ? null : savePassword,
                      child: const Text(
                        'Save',
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
