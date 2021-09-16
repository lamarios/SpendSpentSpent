import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/globals.dart';

class DummyRecurringExpense extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(25)), color: DUMMY_COLOR),
      ),
    );
  }
}
