import 'package:animations/animations.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/screens/categorySettings.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/addCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsCategoryGridItem extends StatelessWidget {

  void showAddCategory(BuildContext context){
    Navigator.push(context, platformPageRoute(context: context, builder: (context) => CategorySettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showAddCategory(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: defaultBorder,
            border: Border.all(width: 3, color: Colors.blue[100]!)),
        child: FaIcon(
          FontAwesomeIcons.cog,
          color: Colors.blue[100],
        ),
      ),
    );
  }
}
