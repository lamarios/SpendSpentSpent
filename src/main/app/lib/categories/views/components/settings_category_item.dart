import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/categories/views/screens/category_settings.dart';
import 'package:spend_spent_spent/globals.dart';

class SettingsCategoryGridItem extends StatelessWidget {
  const SettingsCategoryGridItem({super.key});


  void showAddCategory(BuildContext context){
    Navigator.push(context, platformPageRoute(context: context, builder: (context) => CategorySettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => showAddCategory(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: defaultBorder,
            border: Border.all(width: 3, color: colors.primary.withOpacity(0.5))),
        child: FaIcon(
          FontAwesomeIcons.cog,
          color: colors.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
