import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    user.password = passwordController.text;

    await service.saveUser(user);

    await Fluttertoast.showToast(
        msg: "Password saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  valueChanged() {
    setState(() {
      invalid = (passwordRepeatController.text.trim().length > 0 &&
          passwordRepeatController.text.trim() !=
              passwordController.text.trim());
      canSave = passwordRepeatController.text.trim().length > 0 &&
          passwordController.text.trim().length > 0;
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
            PlatformText('New password'),
            PlatformTextField(
              obscureText: true,
              controller: passwordController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: PlatformText('Repeat new password'),
            ),
            PlatformTextField(
              obscureText: true,
              controller: passwordRepeatController,
            ),
            Visibility(
                visible: invalid,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PlatformText('Passwords don\'t match'),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: invalid || !canSave ? null : savePassword,
                      child: Text(
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
