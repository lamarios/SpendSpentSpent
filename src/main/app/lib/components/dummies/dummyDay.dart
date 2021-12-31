import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/dummyExpense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class DummyDay extends StatelessWidget {
  int expenses;

  DummyDay(this.expenses);

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    double total = 0;
    List<Widget> widgets = [
      Container(
        width: 150,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: colors.dummy,
        ),
      ),
    ];

    List<Widget> wrap = [];
    for (int i = 0; i < expenses; i++) {
      wrap.add(DummyExpense(expenses * 10 + 100));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(runSpacing: 10, spacing: 10, alignment: WrapAlignment.center, children: wrap),
    ));

    widgets.add(
      Container(
        width: 150,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: colors.dummy,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: widgets),
    );
  }
}
