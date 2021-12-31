import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/components/dummies/dummyDay.dart';

class DummyExpenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DummyFade(
      child: ListView(children: [
        DummyDay(4),
        DummyDay(1),
        DummyDay(3),
      ]),
    );
  }
}
