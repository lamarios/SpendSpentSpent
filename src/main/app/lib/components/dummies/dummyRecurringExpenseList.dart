import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';

import 'dummyRecurrinyExpense.dart';

class DummyRecurringExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DummyFade(
      child: ListView(
        children: [
          DummyRecurringExpense(),
          DummyRecurringExpense(),
          DummyRecurringExpense(),
          DummyRecurringExpense(),
          DummyRecurringExpense(),
          DummyRecurringExpense(),
          DummyRecurringExpense(),
        ],
      ),
    );
  }
}
