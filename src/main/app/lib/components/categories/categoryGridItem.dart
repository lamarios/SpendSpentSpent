import 'package:animations/animations.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/category.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/addExpense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryGridItem extends StatefulWidget {
  Category category;

  CategoryGridItem({required this.category});

  @override
  CategoryGridItemState createState() => CategoryGridItemState();
}

class CategoryGridItemState extends State<CategoryGridItem> {

  showDialog(BuildContext context) {
    showModal(
        context: context,
        builder: (context) => Card(
        margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 350, maxHeight: 650),
            child: AddExpense(category: widget.category)));
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return GestureDetector(
      onTap: () => showDialog(context),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: defaultBorder,
            gradient: defaultGradient(context)),
        child: Hero(
            tag: widget.category.icon!,
            child: getIcon(widget.category.icon!, size: 40, color: colors.iconOnMain)),
      ),
    );
  }
}
