import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/DummyFade.dart';

import 'dummyRecurrinyExpense.dart';

class DummyRecurringExpenseList extends StatelessWidget {
  const DummyRecurringExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DummyFade(
      child: ListView(
        children: const [
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
