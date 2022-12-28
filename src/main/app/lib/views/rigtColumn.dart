import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:fbroadcast_nullsafety/fbroadcast_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/components/dummies/dummyExpenses.dart';
import 'package:spend_spent_spent/components/rightColumn/oneDay.dart';
import 'package:spend_spent_spent/components/rightColumn/search.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/dayExpense.dart';
import 'package:spend_spent_spent/models/expense.dart';
import 'package:spend_spent_spent/models/searchParameters.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';
import 'package:spend_spent_spent/utils/dialogs.dart';

import 'expenseView.dart';

class RightColumn extends StatefulWidget {
  RightColumnState createState() => RightColumnState();
}

class RightColumnState extends State<RightColumn> with AfterLayoutMixin {
  List<String> months = [];
  String selected = '';
  Map<String, DayExpense> expenses = {};
  double total = 0;
  Widget expensesWidget = DummyExpenses();
  bool searchMode = false;

  void getMonths() async {
    List<String> months = await service.getExpensesMonths();
    String now = DateFormat("yyyy-MM").format(DateTime.now());
    int nowIndex = months.indexWhere((element) => element == now);
    if (this.mounted) {
      setState(() {
        this.months = months;
        if (months.length > 0 && selected == '' && nowIndex != -1) {
          selected = months[nowIndex];
        } else if (months.length > 0 && selected == '') {
          selected = months[months.length - 1];
        }
        getExpenses();
      });
    }
  }

  @override
  void dispose() {
    FBroadcast.instance()?.unregister(this);
    super.dispose();
  }

  void monthChanged(value) {
    if (this.mounted) {
      setState(() {
        selected = value ?? '';
        getExpenses();
      });
    }
  }

  void showExpense(Expense expense) {
    showModal(context: context, builder: (context) => Card(margin: getInsetsForMaxSize(MediaQuery.of(context), maxWidth: 550, maxHeight: 950), child: ExpenseView(expense)));
  }

  String convertDate(String date) {
    return DateFormat('MMMM yyyy').format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  getExpenses() async {
    setState(() {
      expensesWidget = DummyExpenses();
    });
    var expenses = await service.getMonthExpenses(selected);
    var total = expenses.values.map((e) => e.total).reduce((value, element) => value + element);
    if (this.mounted) {
      setState(() {
        this.expenses = expenses;
        this.total = total;
        expensesWidget = getExpensesWidget();
      });
    }
  }

  switchSearch() {
    setState(() {
      this.searchMode = !this.searchMode;
    });

    if (!this.searchMode) {
      getExpenses();
    } else {
      setState(() {
        this.expenses = Map<String, DayExpense>();
        this.total = 0;
        expensesWidget = getExpensesWidget();
      });
    }
  }

  search(SearchParameters params) async {
    setState(() {
      expensesWidget = DummyExpenses();
    });

    var expenses = await service.search(params);
    double total = expenses.values.length > 0 ? expenses.values.map((e) => e.total).reduce((value, element) => value + element) : 0;
    if (this.mounted) {
      setState(() {
        this.expenses = expenses;
        this.total = total;
        expensesWidget = getExpensesWidget();
      });
    }
  }

  Widget getExpensesWidget() {
    List<String> expensesKeys = expenses.keys.toList();
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return OneDay(showExpense: showExpense, expense: expenses[expensesKeys[index]]!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: AnimatedSwitcher(
                  duration: panelTransition,
                  child: this.searchMode
                      ? Search(
                          search: this.search,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            gradient: defaultGradient(context),
                          ),
                          child: DropdownButton<String>(
                            value: selected,
                            items: months
                                .map((e) => DropdownMenuItem(
                                      child: Text(
                                        convertDate(e),
                                        style: TextStyle(color: colors.textOnMain),
                                      ),
                                      value: e,
                                    ))
                                .toList(),
                            style: TextStyle(color: colors.textOnMain),
                            isExpanded: true,
                            iconEnabledColor: colors.textOnMain,
                            underline: SizedBox.shrink(),
                            isDense: true,
                            dropdownColor: colors.main,
                            onChanged: monthChanged,
                          ),
                        ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    gradient: defaultGradient(context),
                  ),
                  child: IconButton(
                      onPressed: switchSearch,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 15,
                      splashRadius: 15,
                      icon: FaIcon(this.searchMode ? FontAwesomeIcons.xmark : FontAwesomeIcons.magnifyingGlass, color: colors.textOnMain)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Total:', style: TextStyle(color: colors.text)),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatCurrency(total),
                          style: TextStyle(color: colors.main),
                        ))),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(duration: panelTransition, child: expensesWidget),
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getMonths();
    FBroadcast.instance()?.register(BROADCAST_REFRESH_EXPENSES, (context, somethingElse) => getExpenses());
  }
}
