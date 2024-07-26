import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
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

import '../../../views/expenseView.dart';

@RoutePage()
class RightColumnTab extends StatefulWidget {
  const RightColumnTab({super.key});

  @override
  RightColumnTabState createState() => RightColumnTabState();
}

class RightColumnTabState extends State<RightColumnTab> with AfterLayoutMixin {
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
    FBroadcast.instance().unregister(this.context);
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
        this.expenses = <String, DayExpense>{};
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
    final colors = Theme.of(context).colorScheme;
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
                child: AnimatedCrossFade(
                  sizeCurve: Curves.easeInOutQuad,

                  crossFadeState: this.searchMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: panelTransition,
                  firstChild: Search(
                    search: this.search,
                  ),
                  secondChild: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: colors.primaryContainer
                    ),
                    child: DropdownButton<String>(
                      value: selected,
                      items: months
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  convertDate(e),
                                  style: TextStyle(color: colors.onSecondaryContainer),
                                ),
                                value: e,
                              ))
                          .toList(),
                      style: TextStyle(color: colors.onPrimaryContainer),
                      isExpanded: true,
                      iconEnabledColor: colors.onPrimaryContainer,
                      underline: const SizedBox.shrink(),
                      isDense: true,
                      dropdownColor: colors.secondaryContainer,
                      onChanged: monthChanged,
                    ),
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: colors.primaryContainer
                  ),
                  child: IconButton(
                      onPressed: switchSearch,
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 15,
                      splashRadius: 15,
                      icon: FaIcon(this.searchMode ? FontAwesomeIcons.xmark : FontAwesomeIcons.magnifyingGlass, color: colors.onPrimaryContainer)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Total:'),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatCurrency(total),
                          style: TextStyle(color: colors.primary),
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
    // FBroadcast.instance().register(BROADCAST_REFRESH_EXPENSES, (context, somethingElse) => getExpenses());
  }
}
