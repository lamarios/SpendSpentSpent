import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

const double MAP_HEIGHT = 200;
const double NOTE_HEIGHT = 30;

class OneExpense extends StatelessWidget {
  final Expense expense;
  final Function(Expense expense) showExpense;

  const OneExpense(
      {super.key, required this.showExpense, required this.expense});

  openContainer() {
    showExpense(expense);
  }

  bool hasNote() {
    return (expense.note?.length ?? 0) > 0;
  }

  bool hasLocation() {
    return expense.longitude != 0 && expense.latitude != 0;
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: openContainer,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: colors.secondaryContainer),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: colors.primaryContainer),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        getIcon(expense.category.icon!,
                            size: 20, color: colors.onPrimaryContainer),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            formatCurrency(expense.amount),
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: hasLocation(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FaIcon(
                        FontAwesomeIcons.locationArrow,
                        color: colors.onSecondaryContainer,
                        size: 15,
                      ),
                    )),
                Visibility(
                    visible: hasNote(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FaIcon(
                        FontAwesomeIcons.commentDots,
                        color: colors.onSecondaryContainer,
                        size: 15,
                      ),
                    )),
                Visibility(
                    visible: expense.type == 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FaIcon(
                        FontAwesomeIcons.redo,
                        color: colors.onSecondaryContainer,
                        size: 15,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
