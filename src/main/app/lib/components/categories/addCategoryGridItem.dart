import 'package:animations/animations.dart';
import 'package:fbroadcast_nullsafety/fbroadcast_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/addCategory.dart';

class AddCategoryGridItem extends StatelessWidget {
  void addCategory(String selected) async {
    await service.addCategory(selected);
    FBroadcast.instance()?.broadcast(BROADCAST_REFRESH_CATEGORIES);
  }

  void showAddCategory(BuildContext context) {
    showModal(
        context: context,
        builder: (context) => Card(
            margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 350, maxHeight: 500),
            child: AddCategory(
              onSelected: addCategory,
            )));
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return GestureDetector(
      onTap: () => showAddCategory(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: defaultBorder, border: Border.all(width: 3, color: colors.main.withOpacity(0.5))),
        child: FaIcon(
          FontAwesomeIcons.plus,
          color: colors.main.withOpacity(0.5),
        ),
      ),
    );
  }
}
