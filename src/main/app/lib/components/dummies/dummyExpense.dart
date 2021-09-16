import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/globals.dart';

class DummyExpense extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topCenter,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: DUMMY_COLOR,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
