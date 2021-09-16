import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/components/dummies/DummyFade.dart';
import 'package:spend_spent_spent/components/dummies/dummyStats.dart';

class DummyStatsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DummyFade(
        child: ListView(
      children: [
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
        DummyStats(),
      ],
    ));
  }
}
