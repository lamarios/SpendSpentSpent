import 'package:after_layout/after_layout.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  Function onProfileSaved;

  EditProfile({required this.onProfileSaved});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> with AfterLayoutMixin{
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
    user.firstName = firstNameController.text;
    user.lastName = lastNameController.text;

    await service.saveUser(user);

    widget.onProfileSaved();

    await Fluttertoast.showToast(
        msg: "Profile saved", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.green, textColor: Colors.white, fontSize: 16.0);
  }

  valueChanged() {
    setState(() {
      canSave = lastNameController.text.trim().length > 0 && firstNameController.text.trim().length > 0;
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
            PlatformText('First name'),
            PlatformTextField(
              controller: firstNameController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: PlatformText('Last name'),
            ),
            PlatformTextField(
              controller: lastNameController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: PlatformElevatedButton(
                      onPressed: !canSave ? null : savePassword,
                      color: Theme.of(context).primaryColorDark,
                      child: PlatformText(
                        'Save',
                        style: TextStyle(color: Colors.white),
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

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    User user = await service.getCurrentUser();
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
  }
}
