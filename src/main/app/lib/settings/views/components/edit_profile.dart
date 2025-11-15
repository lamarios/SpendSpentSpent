import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/settings/models/user.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final Function onProfileSaved;

  const EditProfile({super.key, required this.onProfileSaved});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> with AfterLayoutMixin {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool canSave = false;

  @override
  initState() {
    super.initState();
    firstNameController.addListener(valueChanged);
    lastNameController.addListener(valueChanged);
  }

  savePassword() async {
    User user = await service.getCurrentUser();
    user = user.copyWith(firstName: firstNameController.text, lastName: lastNameController.text);

    await service.saveUser(user);

    widget.onProfileSaved();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile saved")));
  }

  valueChanged() {
    setState(() {
      canSave = lastNameController.text.trim().isNotEmpty && firstNameController.text.trim().isNotEmpty;
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
            const Text('First name'),
            TextField(controller: firstNameController),
            const Padding(padding: EdgeInsets.only(top: 20.0), child: Text('Last name')),
            TextField(controller: lastNameController),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(onPressed: !canSave ? null : savePassword, child: const Text('Save')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    User user = await service.getCurrentUser();
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
  }
}
