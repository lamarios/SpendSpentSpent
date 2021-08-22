import 'package:app/components/switcher.dart';
import 'package:app/globals.dart';
import 'package:app/views/categoryList.dart';
import 'package:app/views/recurringExpenseList.dart';
import 'package:flutter/cupertino.dart';

class MiddleColumn extends StatefulWidget {
  @override
  MiddleColumnState createState() => MiddleColumnState();
}

class MiddleColumnState extends State<MiddleColumn> {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Switcher(
            selected: selected,
            labels: ['Normal', 'Recurring'],
            onSelect: switchTab,
          ),
        ),
        Expanded(
            child: AnimatedSwitcher(
                duration: panelTransition,
                switchInCurve: Curves.easeInOutQuart,
                switchOutCurve: Curves.easeInOutQuart,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
                child: current))
      ],
    );
  }
}
