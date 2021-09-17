import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/icons.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

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

  deleteRecurringExpense(BuildContext context) {
    AppColors colors = get(context);
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Delete recurring expense ?'),
        content: Text('This will delete the scheduling of the expense, existing expenses won\'t be deleted.'),
        actions: <Widget>[
          PlatformDialogAction(
            onPressed: () => Navigator.pop(context),
            child: PlatformText(
              'Cancel',
              style: TextStyle(color: colors.cancelText),
            ),
          ),
          PlatformDialogAction(
            onPressed: () async {
              await service.deleteRecurringExpense(widget.expense.id!);
              widget.refreshExpenses();
              Navigator.pop(context);
            },
            child: PlatformText('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedContainer(
          curve: Curves.easeInOutQuart,
          height: opened ? 170 : 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: defaultGradient(context),
          ),
          duration: panelTransition,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              children: [
                Row(
                  children: [
                    getIcon(widget.expense.category.icon ?? '', size: 20, color: colors.textOnMain),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          formatCurrency(widget.expense.amount),
                          style: TextStyle(color: colors.textOnMain),
                        ),
                      ),
                    ),
                    Text(
                      getType(widget.expense.type ?? 0),
                      style: TextStyle(color: colors.textOnMain),
                    )
                  ],
                ),
                Visibility(
                    visible: showInfo,
                    child: Expanded(
                      child: FadeIn(
                        duration: panelTransition,
                        curve: Curves.easeInOutQuart,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            child: Column(
                              children: [
                                Visibility(
                                  visible: widget.expense.lastOccurrence != null,
                                  child: Text(
                                    'Last occurrence: ' + (widget.expense.lastOccurrence ?? ''),
                                    style: TextStyle(color: colors.textOnMain),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    'Next occurrence: ' + (widget.expense.nextOccurrence ?? ''),
                                    style: TextStyle(color: colors.textOnMain),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                Visibility(
                    visible: showInfo,
                    child: Row(
                      children: [
                        Expanded(
                            child: FadeIn(
                          duration: panelTransition,
                          curve: Curves.easeInOutQuart,
                          child: PlatformButton(
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                            onPressed: () => deleteRecurringExpense(context),
                          ),
                        )),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
