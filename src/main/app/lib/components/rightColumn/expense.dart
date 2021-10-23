import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

const double MAP_HEIGHT = 200;
const double NOTE_HEIGHT = 30;

class OneExpense extends StatefulWidget {
  Expense expense;
  Function showExpense;
  Key? key;

  OneExpense({this.key, required this.showExpense, required this.expense});

  @override
  OneExpenseState createState() => OneExpenseState();
}

class OneExpenseState extends State<OneExpense> {

  openContainer() {
    widget.showExpense(widget.expense);
  }

  bool hasNote() {
    return (widget.expense.note?.length ?? 0) > 0;
  }

  bool hasLocation() {
    return widget.expense.longitude != 0 && widget.expense.latitude != 0;
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return GestureDetector(
      onTap: openContainer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              gradient: defaultGradient(context),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  getIcon(widget.expense.category.icon!, size: 20, color: colors.iconOnMain),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                  formatCurrency(widget.expense.amount),
                  style: TextStyle(color: colors.textOnMain),
                    ),
                  ),
                  Visibility(
                      visible: hasLocation(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.locationArrow,
                          color: colors.textOnMain,
                          size: 15,
                        ),
                      )),
                  Visibility(
                      visible: hasNote(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.commentDots,
                          color: colors.textOnMain,
                          size: 15,
                        ),
                      )),
                  Visibility(
                      visible: widget.expense.type == 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.redo,
                          color: colors.textOnMain,
                          size: 15,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
