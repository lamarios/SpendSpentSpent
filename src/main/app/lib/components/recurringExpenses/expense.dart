import 'dart:async';

import 'package:app/globals.dart';
import 'package:app/icons.dart';
import 'package:app/models/recurringExpense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Expense extends StatefulWidget {
  RecurringExpense expense;
  Function refreshExpenses;

  Expense({required this.expense, required this.refreshExpenses});

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
          setState(() {
            showInfo = !showInfo;
          });
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
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text('Delete recurring expense ?'),
        content: Text('This will delete the scheduling of the expense, existing expenses won\'t be deleted.'),
        actions: <Widget>[
          PlatformDialogAction(
            onPressed: () => Navigator.pop(context),
            child: PlatformText('Cancel'),
          ),
          PlatformDialogAction(
            onPressed: () async {
              await service.deleteRecurringExpense(widget.expense.id!);
              widget.refreshExpenses();
              Navigator.pop(context);
            },
            child: PlatformText('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: AnimatedContainer(
          curve: Curves.easeInOutQuart,
          height: opened ? 150 : 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue], stops: [0, 0.75], begin: Alignment.bottomCenter, end: Alignment.topRight),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          duration: panelTransition,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              children: [
                Row(
                  children: [
                    getIcon(widget.expense.category.icon ?? '', size: 20, color: Colors.white),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          widget.expense.amount.toStringAsFixed(2),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Text(
                      getType(widget.expense.type ?? 0),
                      style: TextStyle(color: Colors.white),
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
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    'Next occurrence: ' + (widget.expense.nextOccurrence ?? ''),
                                    style: TextStyle(color: Colors.white),
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
                            color: Theme.of(context).primaryColorDark,
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
