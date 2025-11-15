import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:spend_spent_spent/utils/stringUtils.dart';

class AddUserDialog extends StatefulWidget {
  final Function saveUser;

  const AddUserDialog({super.key, required this.saveUser});

  @override
  AddUserDialogState createState() => AddUserDialogState();
}

class AddUserDialogState extends State<AddUserDialog> {
  TextEditingController emailController = TextEditingController(),
      firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      passwordController = TextEditingController();

  void addUser(BuildContext context) {
    User user = User(
      email: emailController.text,
      firstName: firstNameController.text,
      isAdmin: false,
      lastName: lastNameController.text,
      password: passwordController.text,
    );
    widget.saveUser(user);
    Navigator.pop(context);
  }

  bool valid() {
    return emailController.text.isNotEmpty &&
        isValidEmail(emailController.text) &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  void randomPassword() {
    var r = Random.secure();
    passwordController.text = randomAlpha(16, provider: CoreRandomProvider.from(r));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              decoration: const InputDecoration(hintText: 'j.doe@example.org'),
              controller: emailController,
            ),
          ),
          const Text('First name'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              decoration: const InputDecoration(hintText: 'John'),
              controller: firstNameController,
            ),
          ),
          const Text('Last name'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextField(
              decoration: const InputDecoration(hintText: 'Doe'),
              controller: lastNameController,
            ),
          ),
          const Text('Password'),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextField(controller: passwordController),
          ),
          TextButton(onPressed: randomPassword, child: const Text('Generate password')),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(color: Colors.grey[850])),
              ),
              TextButton(onPressed: () => addUser(context), child: const Text('Save')),
            ],
          ),
        ],
      ),
    );
  }
}
