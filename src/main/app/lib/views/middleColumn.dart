import 'package:after_layout/after_layout.dart';
import 'package:auto_route/auto_route.dart';
import 'package:spend_spent_spent/utils/views/components/switcher.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/categories/views/components/category_list.dart';
import 'package:spend_spent_spent/views/recurringExpenseList.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class MiddleColumnTab extends StatefulWidget {
  @override
  MiddleColumnTabState createState() => MiddleColumnTabState();
}

class MiddleColumnTabState extends State<MiddleColumnTab> {
  Widget current = CategoryList();
  int selected = 0;

  void switchTab(int selected) {
    setState(() {
      this.selected = selected;
      current = selected == 0 ? CategoryList() : RecurringExpenseList();
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Switcher(
              selected: selected,
              labels: const ['Normal', 'Recurring'],
              onSelect: switchTab,
            ),
          ),
          Expanded(
              child: AnimatedSwitcher(
                  duration: panelTransition,
                  switchInCurve: Curves.easeInOutQuart,
                  switchOutCurve: Curves.easeInOutQuart,
                  child: current))
        ],
      ),
    );
  }
}
