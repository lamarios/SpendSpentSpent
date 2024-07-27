import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/utils/views/components/dummies/dummyDay.dart';

class DummyExpenses extends StatelessWidget {
  const DummyExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return DummyFade(
      child: ListView(children: const [
        DummyDay(4),
        DummyDay(1),
        DummyDay(3),
      ]),
    );
  }
}
