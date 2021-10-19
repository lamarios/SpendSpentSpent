import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class ChangePasswordDialog extends StatefulWidget {
  String userId;

  ChangePasswordDialog({required this.userId});

  @override
  ChangePasswordDialogState createState() => ChangePasswordDialogState();
}

class ChangePasswordDialogState extends State<ChangePasswordDialog> with AfterLayoutMixin {
  TextEditingController passwordController = TextEditingController();

  void randomPassword() {
    var r = Random.secure();
    passwordController.text = randomAlpha(16, provider: CoreRandomProvider.from(r));
  }

  Future<void> savePassword(BuildContext context) async {
    await service.setUserPassword(widget.userId, passwordController.text.trim());
    Navigator.of(context).pop();

    await Fluttertoast.showToast(
        msg: "Password saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Password'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: PlatformTextField(
              controller: passwordController,
            ),
          ),
          PlatformButton(
            child: Text('Generate password'),
            onPressed: randomPassword,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PlatformDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: PlatformText(
                  'Cancel',
                  style: TextStyle(color: colors.text),
                ),
              ),
              PlatformDialogAction(
                onPressed: passwordController.text.trim().length > 0 ? () => savePassword(context) : null,
                child: PlatformText('Save', style: TextStyle(color: colors.main)),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // fix for web as changing password would not enabled the save button
    passwordController.addListener(() {
      setState(() {
      });
    });
  }
}
