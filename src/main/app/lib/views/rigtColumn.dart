import 'package:after_layout/after_layout.dart';
import 'package:app/components/rightColumn/oneDay.dart';
import 'package:app/globals.dart';
import 'package:app/models/dayExpense.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RightColumn extends StatefulWidget {
  RightColumnState createState() => RightColumnState();
}

class RightColumnState extends State<RightColumn> with AfterLayoutMixin {
  List<String> months = [];
  String selected = '';
  Map<String, DayExpense> expenses = {};
  double total = 0;

  void getMonths() async {
    List<String> months = await service.getExpensesMonths();
    String now = DateFormat("yyyy-MM").format(DateTime.now());
    int nowIndex = months.indexWhere((element) => element == now);
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

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  void monthChanged(value) {
    setState(() {
      selected = value ?? '';
      getExpenses();
    });
  }

  String convertDate(String date) {
    return DateFormat('MMMM yyyy').format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  getExpenses() async {
    var expenses = await service.getMonthExpenses(selected);
    var total = expenses.values.map((e) => e.total).reduce((value, element) => value + element);
    setState(() {
      this.expenses = expenses;
      this.total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> expensesKeys = expenses.keys.toList();
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Column(
        children: [
          Container(
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
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: DropdownButton<String>(
                      value: selected,
                      items: months
                          .map((e) => DropdownMenuItem(
                                child: Text(convertDate(e)),
                                value: e,
                              ))
                          .toList(),
                      style: TextStyle(color: Colors.white),
                      isExpanded: true,
                      iconEnabledColor: Colors.white,
                      underline: SizedBox.shrink(),
                      isDense: true,
                      dropdownColor: Colors.blue,
                      onChanged: monthChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Total:'),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatCurrency(total),
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return OneDay(expense: expenses[expensesKeys[index]]!);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getMonths();
    FBroadcast.instance().register(BROADCAST_REFRESH_EXPENSES,
            (context, somethingElse) => getExpenses());
  }
}
