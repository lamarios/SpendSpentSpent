import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/dummyExpense.dart';
import 'package:spend_spent_spent/globals.dart';

class DummyDay extends StatelessWidget {
  int expenses;

  DummyDay(this.expenses);

  @override
  Widget build(BuildContext context) {
    double total = 0;
    List<Widget> widgets = [
      Container(
        width: 150,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: DUMMY_COLOR,
        ),
      ),
    ];

    for (int i = 0; i < expenses; i++) {
      widgets.add(DummyExpense());
    }

    widgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatCurrency(total),
                    style: TextStyle(color: DUMMY_COLOR),
                  ))),
        ],
      ),
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: widgets),
    );
  }
}
