import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';
import 'package:spend_spent_spent/views/recurringExpenseView.dart';

class Expense extends StatefulWidget {
  final RecurringExpense expense;
  final Function refreshExpenses;

  const Expense(
      {super.key, required this.expense, required this.refreshExpenses});

  @override
  ExpenseState createState() => ExpenseState();
}

class ExpenseState extends State<Expense> with AfterLayoutMixin {
  bool opened = false;
  bool showInfo = false;

  Offset offset = const Offset(-1, 0);
  double opacity = 0;

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
            margin: getInsetsForMaxSize(MediaQuery.of(context),
                maxWidth: 550, maxHeight: 950),
            child: RecurringExpenseView(
              widget.expense,
              refreshExpenses: widget.refreshExpenses,
            )));
  }

  @override
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => openContainer(context),
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: colors.surfaceBright),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      getIcon(widget.expense.category.icon!,
                          size: 20, color: colors.onSecondaryContainer),
                      Visibility(
                        visible: widget.expense.name.trim().isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.expense.name.trim(),
                            style:
                                TextStyle(color: colors.onSecondaryContainer),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                        child: AnimatedOpacity(
                          opacity: opacity,
                          duration: panelTransition,
                          child: AnimatedSlide(
                            duration: panelTransition,
                            curve: Curves.easeInOutQuart,
                            offset: offset,
                            child: Text(
                              formatCurrency(widget.expense.amount),
                              style:
                                  TextStyle(color: colors.onSecondaryContainer),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
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
                      getIcon(widget.expense.category.icon!,
                          size: 20, color: colors.onPrimaryContainer),
                      Visibility(
                        visible: widget.expense.name.trim().isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            widget.expense.name.trim(),
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Random rand = Random();
    Future.delayed(Duration(milliseconds: rand.nextInt(250)), () {
      setState(() {
        offset += const Offset(1, 0);
        opacity = 1;
      });
    });
  }
}
