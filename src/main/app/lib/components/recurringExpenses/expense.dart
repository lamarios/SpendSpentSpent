import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/recurringExpenseView.dart';

class Expense extends StatefulWidget {
  RecurringExpense expense;
  Function refreshExpenses;
  Key? key;

  Expense({this.key, required this.expense, required this.refreshExpenses});

  ExpenseState createState() => ExpenseState();
}

class ExpenseState extends State<Expense> {
  bool opened = false;
  bool showInfo = false;

  toggle() {
    setState(() {
      opened = !opened;
      if (opened) {
        Future.delayed(panelTransition, () {
          if (opened) {
            setState(() {
              showInfo = !showInfo;
            });
          }
        });
      } else {
        showInfo = false;
      }
    });
  }

  getType(int type) {
    switch (type) {
      case 0:
        return 'Daily';
      case 1:
        return 'Weekly';
      case 2:
        return 'Monthly';
      case 3:
        return 'Yearly';
    }
  }

  openContainer(BuildContext context) {
    showModal(
        context: context,
        builder: (context) => Card(
            margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 550, maxHeight: 950),
            child: RecurringExpenseView(
              widget.expense,
              refreshExpenses: widget.refreshExpenses,
            )));
  }

  @override
  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return GestureDetector(
      onTap: () => openContainer(context),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
